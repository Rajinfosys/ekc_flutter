import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/widgets/general_widgets.dart';

import '../../../core/utils/app_color.dart';
import '../../core/utils/styles.dart';
import 'add_product_screen.dart';
import 'controller/branding_sales_controller.dart';

class ListOfProductScreen extends GetView<BrandingSalesController> {
  const ListOfProductScreen({super.key});

  static const routeName = '/list-of-product';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Products',
          style: appBarStyle,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(AddProductScreen.routeName);
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
              AddProductScreen.routeName,
            );
          },
          backgroundColor: AppColors.white2,
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      body: Obx(
        () => Container(
          child: controller.isLoading.value || controller.isEditLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : controller.listOfProducts.isEmpty
                  ? const Center(
                      child: Text(
                        'No Product available',
                        style: TextStyle(color: Colors.black, fontSize: 25),
                      ),
                    )
                  : ListView.builder(
                      itemBuilder: (ctx, i) {
                        return cardProductWidget(
                          controller.listOfProducts[i],
                        );
                      },
                      itemCount: controller.listOfProducts.length,
                    ),
        ),
      ),
    );
  }
}
