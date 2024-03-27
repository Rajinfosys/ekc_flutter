import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/core/utils/app_color.dart';
import 'package:qr_code_scanner/presentation/home_screen/controller/home_controller.dart';

import '../../widgets/general_widgets.dart';
import 'add_outlet_screen.dart';
import 'controller/outlet_controller.dart';

class ListOfOutletsScreen extends GetView<OutletController> {
  static const routeName = '/list-of-outlets';

  const ListOfOutletsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        title: ('List of Outlets'),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(AddOutletScreen.routeName);
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
            Get.toNamed(AddOutletScreen.routeName);
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
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: SearchBar(
                        elevation: MaterialStateProperty.all(2),
                        backgroundColor:
                            MaterialStateProperty.all(AppColors.white),
                        surfaceTintColor:
                            MaterialStateProperty.all(AppColors.white),
                        // textInputAction: TextInputAction.done,
                        leading: const Icon(Icons.search),
                        hintText: 'Search Outlets',
                        onChanged: HomePageController.instance.searchOutlets,
                      ),
                    ),
                    if (HomePageController.instance.listOfOutlets.isEmpty)
                      const Expanded(
                        child: Center(
                          child: Text(
                            'No Outlets',
                            style: TextStyle(color: Colors.black, fontSize: 25),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (ctx, i) {
                            return cardOutletWidget(
                              HomePageController.instance.listOfOutlets[i],
                            );
                          },
                          itemCount:
                              HomePageController.instance.listOfOutlets.length,
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
