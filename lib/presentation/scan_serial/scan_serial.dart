import 'package:get_storage/get_storage.dart';
import 'package:qr_code_scanner/core/utils/global_variables.dart';
import 'package:qr_code_scanner/core/utils/log_util.dart';
import 'package:qr_code_scanner/presentation/branding_sales/models/product_model.dart';
import 'package:qr_code_scanner/presentation/scan_serial/controller/serial_controller.dart';
import 'package:qr_code_scanner/presentation/scan_serial/models/gas_model.dart';
import 'package:qr_code_scanner/widgets/general_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';

import '../../core/utils/app_color.dart';
// import 'controller/outlet_controller.dart';
// import 'models/areas_model.dart';
// import 'models/city_model.dart';

class ScanSerialView extends GetView<ScanSerialController> {
  ScanSerialView({Key? key}) : super(key: key);
  static const routeName = '/scan-serial';
  final formKey = GlobalKey<FormState>();

  Future<void> scanQrNormal() async {
    String qrScanRes;
    try {
      qrScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      debugPrint(qrScanRes);
    } on PlatformException {
      qrScanRes = 'Failed to get platform version.';
    }

    // if (!mounted) return;
    // setState(() {
    //   _scanQrResult = qrScanRes;
    // });

    controller.code.value.text = qrScanRes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarWidget(
        title: "Serial QR code scan",
        leading: const Icon(CupertinoIcons.arrow_left),
      ),
      body: Obx(() => (controller.isLoading.value ||
              controller.isEditLoading.value)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: SizedBox(
                width: Get.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 16),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        myText(
                            text: "Select Product",
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 18)),
                        SizedBox(
                          height: Get.height * dropSize,
                        ),
                        DropdownSearch<ProductModel>(
                          validator: (ProductModel? input) {
                            if (input?.productName == null) {
                              Get.snackbar('Warning', 'Select Product',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.blue);
                              return '';
                            }
                            return null;
                          },
                          items: controller.productList.toList(),
                          itemAsString: (ProductModel u) => u.productName!,
                          onChanged: controller.setProductValue,
                          compareFn:
                              (ProductModel? item1, ProductModel? item2) =>
                                  true,
                          popupProps: PopupProps.menu(
                            isFilterOnline: true,
                            showSearchBox: true,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        myText(
                            text: "Select Gas",
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 18)),
                        SizedBox(
                          height: Get.height * dropSize,
                        ),
                        DropdownSearch<GasModel>(
                          validator: (GasModel? input) {
                            if (input?.gasName == null) {
                              Get.snackbar('Warning', 'Select Gas',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.blue);
                              return '';
                            }
                            return null;
                          },
                          items: controller.gasList.toList(),
                          itemAsString: (GasModel u) => u.gasName!,
                          onChanged: controller.setGasValue,
                          compareFn: (GasModel? item1, GasModel? item2) => true,
                          popupProps: PopupProps.menu(
                            isFilterOnline: true,
                            showSearchBox: true,
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: ElevatedButton(
                                onPressed: scanQrNormal,
                                child: const Text('Scan'),
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 7,
                              child: myTextField(
                                text: "Code",
                                controller: controller.code.value,
                                validator: (String input) {
                                  if (input.isEmpty) {
                                    Get.snackbar('Warning', 'Code is required.',
                                        colorText: Colors.white,
                                        backgroundColor: Colors.blue);
                                    return '';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Get.height * textMidSize,
                        ),
                        Obx(
                          () => controller.isLoading.value
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Center(
                                  child: SizedBox(
                                    height: 50,
                                    width: Get.width * 0.5,
                                    child: elevatedButton(
                                      text: 'Submit',
                                      onPress: () {
                                        // if (!formKey.currentState!
                                        //     .validate()) {
                                        //   LogUtil.warning(
                                        //       'error in inserting or updating outlet');
                                        //   return;
                                        // }
                                        // Get.arguments != null
                                        //     ? controller.updateOutlet()
                                        //     : controller.insertOutlet();
                                      },
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
    );
  }
}
