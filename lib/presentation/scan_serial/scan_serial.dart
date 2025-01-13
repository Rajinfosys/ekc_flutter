import 'package:ekc_scan/core/utils/global_variables.dart';
import 'package:ekc_scan/core/utils/log_util.dart';
import 'package:ekc_scan/presentation/home_screen/controller/home_controller.dart';
import 'package:ekc_scan/presentation/home_screen/models/gas_model.dart';
import 'package:ekc_scan/presentation/home_screen/models/product_model.dart';
import 'package:ekc_scan/presentation/home_screen/models/reason_model.dart';
import 'package:ekc_scan/presentation/qrscanner/controller/qr_scanner_controller.dart';
import 'package:ekc_scan/presentation/scan_serial/controller/serial_controller.dart';
import 'package:ekc_scan/widgets/general_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:torch_controller/torch_controller.dart';

import '../../core/utils/app_color.dart';

class ScanSerialView extends GetView<ScanSerialController> {
  ScanSerialView({Key? key}) : super(key: key);
  static const routeName = '/scan-serial';
  final formKey = GlobalKey<FormState>();
  // final torchController = TorchController();

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarWidget(
        title: "Serial QR code scan",
        leading: const Icon(CupertinoIcons.arrow_left),
      ),
      body: Obx(() => !controller.isInitialized.value
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.green,
              ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            myText(
                                text: "Is Client Serial No.",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18)),
                            const SizedBox(
                              width: 25,
                            ),
                            Switch(
                                // This bool value toggles the switch.
                                value: controller.isClientSr.value,
                                activeColor: Colors.green,
                                onChanged: controller.qcData.value == null
                                    ? (bool value) {
                                        controller.isClientSr.value = value;
                                      }
                                    : null),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        myText(
                            text: "Product",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18)),
                        SizedBox(
                          height: Get.height * dropSize,
                        ),
                        DropdownButtonFormField<ProductModel>(
                          validator: (ProductModel? input) {
                            if (input?.productName == null) {
                              Get.snackbar('Warning', 'Select Product',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.blue);
                              return '';
                            }
                            return null;
                          },
                          // enabled: controller.qcData.value == null,
                          // selectedItem: controller.selectedProduct.value,
                          items: HomePageController.instance.productList
                              .map<DropdownMenuItem<ProductModel>>(
                                  (ProductModel? value) {
                            return DropdownMenuItem<ProductModel>(
                              value: value,
                              child: Text(
                                '${value?.productName}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          // itemAsString: (ProductModel u) => u.productName!,
                          onChanged: controller.setProductValue,
                          // compareFn:
                          //     (ProductModel? item1, ProductModel? item2) =>
                          //         true,
                          // popupProps: const PopupProps.menu(
                          //   isFilterOnline: true,
                          //   showSearchBox: true,
                          // ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        myText(
                            text: "Gas",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18)),
                        SizedBox(
                          height: Get.height * dropSize,
                        ),
                        DropdownButtonFormField<GasModel>(
                          validator: (GasModel? input) {
                            if (input?.gasName == null) {
                              Get.snackbar('Warning', 'Select Gas',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.blue);
                              return '';
                            }
                            return null;
                          },
                          items: HomePageController.instance.gasList
                              .map<DropdownMenuItem<GasModel>>(
                                  (GasModel value) {
                            return DropdownMenuItem<GasModel>(
                              value: value,
                              child: Text(
                                '${value.gasName}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          // enabled: controller.qcData.value == null,
                          // items:
                          //     HomePageController.instance.gasList.toList(),
                          // itemAsString: (GasModel u) => u.gasName!,
                          // selectedItem: controller.selectedGas.value,
                          onChanged: controller.setGasValue,
                          // compareFn: (GasModel? item1, GasModel? item2) =>
                          //     true,
                          // popupProps: const PopupProps.menu(
                          //   isFilterOnline: true,
                          //   showSearchBox: true,
                          // ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: ElevatedButton(
                                onPressed: () async {
                                  controller.code.value.text = '';
                                  // Get.toNamed(QrScannerScreen.routeName, arguments: 'scan') ;
                                  QRScannerController.instance
                                      .openQrScannerScreen(
                                          'scan'); // or 'packlist'

                                  if (QRScannerController
                                          .instance.scannedResult.value !=
                                      '') {
                                    controller.code.value.text =
                                        QRScannerController
                                            .instance.scannedResult.value;
                                  }
                                },

                                style: ButtonStyle(
                                    shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                      Colors.grey[300]!,
                                    ),
                                    foregroundColor:
                                        WidgetStateProperty.all<Color>(
                                            Colors.black)),

                                // set qr code icon
                                child: const Icon(Icons.qr_code),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Obx(
                              () => Expanded(
                                flex: 7,
                                child: myTextField(
                                  text: "Code",
                                  controller: controller.code.value,
                                  enabled: controller.qcData.value == null,
                                  validator: (String input) {
                                    if (input.isEmpty) {
                                      Get.snackbar(
                                          'Warning', 'Code is required.',
                                          colorText: Colors.white,
                                          backgroundColor: Colors.blue);
                                      return '';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            myText(
                                text: "Is Testing",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18)),
                            const SizedBox(
                              width: 25,
                            ),
                            Switch(
                                // This bool value toggles the switch.
                                value: controller.isTesting.value,
                                activeColor: Colors.green,
                                onChanged: controller.qcData.value == null
                                    ? (bool value) {
                                        controller.isTesting.value = value;
                                      }
                                    : null),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Obx(
                          () => controller.isLoading.value
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.green,
                                  ),
                                )
                              : Center(
                                  child: SizedBox(
                                    height: 50,
                                    width: Get.width * 0.5,
                                    child: elevatedButton(
                                      text: 'Submit',
                                      onPress: () {
                                        if (!formKey.currentState!.validate()) {
                                          LogUtil.warning(
                                              'Please fill all the fields.');
                                          return;
                                        }

                                        if (controller.qcData.value == null) {
                                          controller.updateSerial();
                                        } else {
                                          controller.updateQc();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        controller.qcData.value != null &&
                                controller.qcData.value!.qc_rows!.isNotEmpty
                            ? SizedBox(
                                height: 600,
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      controller.qcData.value!.qc_rows!.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 50,
                                              child: myText(
                                                  maxLines: 2,
                                                  text: controller.qcData.value!
                                                      .qc_rows![index].qc_name!,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16)),
                                            ),
                                            const SizedBox(
                                              width: 25,
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                  value: "Yes",
                                                  groupValue: controller
                                                      .qcData
                                                      .value!
                                                      .qc_rows![index]
                                                      .qc_ok,
                                                  onChanged: (value) {
                                                    controller.handleQcChange(
                                                        value.toString(),
                                                        "qc_ok",
                                                        controller.qcData.value!
                                                            .qc_rows![index]);
                                                  },
                                                ),
                                                myText(
                                                    text: "OK",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 18)),
                                                Radio(
                                                  value: "NA",
                                                  groupValue: controller
                                                      .qcData
                                                      .value!
                                                      .qc_rows![index]
                                                      .qc_ok,
                                                  onChanged: (value) {
                                                    controller.handleQcChange(
                                                        value.toString(),
                                                        "qc_ok",
                                                        controller.qcData.value!
                                                            .qc_rows![index]);
                                                  },
                                                ),
                                                myText(
                                                    text: "NA",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 18)),
                                                Radio(
                                                  value: "No",
                                                  groupValue: controller
                                                      .qcData
                                                      .value!
                                                      .qc_rows![index]
                                                      .qc_ok,
                                                  onChanged: (value) {
                                                    controller.handleQcChange(
                                                        value.toString(),
                                                        "qc_ok",
                                                        controller.qcData.value!
                                                            .qc_rows![index]);
                                                  },
                                                ),
                                                myText(
                                                    text: "Reject",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 18)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        controller.qcData.value!.qc_rows![index]
                                                    .qc_ok ==
                                                "No"
                                            ? DropdownButtonFormField<
                                                ReasonModel>(
                                                validator:
                                                    (ReasonModel? input) {
                                                  if (input?.reasonName ==
                                                      null) {
                                                    Get.snackbar('Warning',
                                                        'Select Reason',
                                                        colorText: Colors.white,
                                                        backgroundColor:
                                                            Colors.blue);
                                                    return '';
                                                  }
                                                  return null;
                                                },
                                                // items: controller.reasonList
                                                //     .toList(),
                                                items: HomePageController
                                                    .instance.reasonList
                                                    .map<
                                                            DropdownMenuItem<
                                                                ReasonModel>>(
                                                        (ReasonModel value) {
                                                  return DropdownMenuItem<
                                                      ReasonModel>(
                                                    value: value,
                                                    child: Text(
                                                      '${value.reasonName}',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  );
                                                }).toList(),

                                                // itemAsString:
                                                //     (ReasonModel u) =>
                                                //         u.reasonName!,
                                                onChanged:
                                                    (ReasonModel? value) {
                                                  controller.handleQcChange(
                                                      value!.reasonName!,
                                                      "qc_reason",
                                                      controller.qcData.value!
                                                          .qc_rows![index]);
                                                },
                                                // compareFn:
                                                //     (ReasonModel? item1,
                                                //             ReasonModel?
                                                //                 item2) =>
                                                //         true,
                                                // popupProps: const PopupProps.menu(
                                                //   isFilterOnline: true,
                                                //   showSearchBox: true,
                                                // ),
                                              )
                                            : Container(),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        index !=
                                                controller.qcData.value!
                                                        .qc_rows!.length -
                                                    1
                                            ? const Divider(
                                                color: Colors.black,
                                              )
                                            : Container(),
                                      ],
                                    );
                                  },
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
            )),
    );
  }
}
