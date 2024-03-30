import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/core/utils/app_color.dart';
import 'package:qr_code_scanner/presentation/home_screen/controller/home_controller.dart';
import 'package:qr_code_scanner/presentation/packing_list/packing_list.dart';
import 'package:qr_code_scanner/presentation/scan_serial/scan_serial.dart';
import 'package:qr_code_scanner/presentation/widgets/home_screen_dart.dart';
import 'package:qr_code_scanner/widgets/general_widgets.dart';

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
                      ],
                    ),
                  ],
                ),
              ),
      ),
      bottomSheet: Container(
        margin: const EdgeInsets.all(12.0),
        child: myText(text: 'App Version - 1.0'),
      ),
    );
  }
}
