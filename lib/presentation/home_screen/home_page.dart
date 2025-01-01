import 'package:ekc_scan/core/utils/app_color.dart';
import 'package:ekc_scan/presentation/home_screen/controller/home_controller.dart';
import 'package:ekc_scan/presentation/packing_list/packing_list.dart';
import 'package:ekc_scan/presentation/packing_list/partial_packing_list.dart';
import 'package:ekc_scan/presentation/scan_serial/scan_serial.dart';
import 'package:ekc_scan/presentation/widgets/home_screen_dart.dart';
import 'package:ekc_scan/widgets/general_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});

  static const routeName = '/home-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        title: 'Dashboard',
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                controller.showOtherUserContextMenu();
              },
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50.0, right: 16),
        child: FloatingActionButton(
          onPressed: () async {
            controller.isInitialized.value = false;
            await controller.getDdlData();
            controller.isInitialized.value = true;
          },
          backgroundColor: AppColors.white2,
          child: const Icon(CupertinoIcons.refresh, color: AppColors.green),
        ),
      ),
      body: Obx(
        () => !controller.isInitialized.value
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.green,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            HomeScreenCard(
                              color: Colors.orange,
                              imageFile: 'assets/images/scan.png',
                              label: "Scan Serials",
                              onTap: () {
                                Get.toNamed(ScanSerialView.routeName);
                              },
                            ),
                            HomeScreenCard(
                              color: Colors.lightGreen,
                              imageFile: 'assets/images/pack_list.png',
                              label: "Scan Packing List",
                              onTap: () {
                                Get.toNamed(PackListView.routeName);
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            HomeScreenCard(
                              color: Colors.lightGreen,
                              imageFile: 'assets/images/to-do-list.png',
                              label: "Partial Packing Lists",
                              onTap: () {
                                Get.toNamed(PartialPackListView.routeName);
                              },
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
      bottomSheet: Container(
        margin: const EdgeInsets.all(12.0),
        child: myText(text: 'App Version - 1.2.0'),
      ),
    );
  }
}
