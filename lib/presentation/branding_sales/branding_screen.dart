import 'package:qr_code_scanner/core/utils/styles.dart';

import 'package:qr_code_scanner/widgets/general_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/app_color.dart';
import 'add_branding_screen.dart';
import 'controller/branding_sales_controller.dart';

class ListOfBrandingScreen extends GetView<BrandingSalesController> {
  const ListOfBrandingScreen({super.key});

  static const routeName = '/list-of-branding';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Branding',
          style: appBarStyle,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(
                AddBrandingScreen.routeName,
              );
            },
            icon: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(
                CupertinoIcons.add,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 32.0, right: 16),
        child: FloatingActionButton(
          onPressed: () {
            Get.toNamed(
              AddBrandingScreen.routeName,
            );
          },
          backgroundColor: AppColors.white2,
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      body: Obx(
        () => Container(
          child: controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : controller.listOfBranding.isEmpty
                  ? const Center(
                      child: Text(
                        'No branding, pls add branding',
                        style: TextStyle(color: Colors.black, fontSize: 25),
                      ),
                    )
                  : ListView.builder(
                      itemBuilder: (ctx, i) {
                        return cardBrandingWidget(
                          controller.listOfBranding[i],
                        );
                      },
                      itemCount: controller.listOfBranding.length,
                    ),
        ),
      ),
    );
  }
}
