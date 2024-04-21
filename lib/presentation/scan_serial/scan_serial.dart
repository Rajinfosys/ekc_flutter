import 'package:get_storage/get_storage.dart';
import 'package:ekc_scan/core/utils/global_variables.dart';
import 'package:ekc_scan/core/utils/log_util.dart';
import 'package:ekc_scan/presentation/home_screen/controller/home_controller.dart';
import 'package:ekc_scan/presentation/home_screen/models/gas_model.dart';
import 'package:ekc_scan/presentation/home_screen/models/product_model.dart';
import 'package:ekc_scan/presentation/home_screen/models/reason_model.dart';
import 'package:ekc_scan/presentation/scan_serial/controller/serial_controller.dart';
import 'package:ekc_scan/widgets/general_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/foundation.dart';

import '../../core/utils/app_color.dart';

class ScanSerialView extends GetView<ScanSerialController> {
  ScanSerialView({Key? key}) : super(key: key);
  static const routeName = '/scan-serial';
  final formKey = GlobalKey<FormState>();

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrController;

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
      body: Obx(() => !controller.isInitialized.value
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.green,
              ),
            )
          : controller.isScanning.value == true
              ? Column(
                  children: <Widget>[
                    Expanded(flex: 9, child: _buildQrView(context)),
                    Expanded(
                      flex: 1,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   crossAxisAlignment: CrossAxisAlignment.center,
                            //   children: <Widget>[
                            //     Container(
                            //       margin: const EdgeInsets.all(8),
                            //       child: ElevatedButton(
                            //           onPressed: () async {
                            //             await qrController?.toggleFlash();
                            //           },
                            //           style: ButtonStyle(
                            //               backgroundColor:
                            //                   MaterialStateProperty.all<Color>(
                            //                 Colors.grey[300]!,
                            //               ),
                            //               foregroundColor:
                            //                   MaterialStateProperty.all<Color>(
                            //                       Colors.black)),
                            //           child: FutureBuilder(
                            //             future: qrController?.getFlashStatus(),
                            //             builder: (context, snapshot) {
                            //               return Text(
                            //                   'Flash: ${snapshot.data}');
                            //             },
                            //           )),
                            //     ),
                            //     Container(
                            //       margin: const EdgeInsets.all(8),
                            //       child: ElevatedButton(
                            //           onPressed: () async {
                            //             await qrController?.flipCamera();
                            //           },
                            //           style: ButtonStyle(
                            //               backgroundColor:
                            //                   MaterialStateProperty.all<Color>(
                            //                 Colors.grey[300]!,
                            //               ),
                            //               foregroundColor:
                            //                   MaterialStateProperty.all<Color>(
                            //                       Colors.black)),
                            //           child: FutureBuilder(
                            //             future: qrController?.getCameraInfo(),
                            //             builder: (context, snapshot) {
                            //               if (snapshot.data != null) {
                            //                 return Text(
                            //                     'Camera facing ${describeEnum(snapshot.data!)}');
                            //               } else {
                            //                 return const Text('loading');
                            //               }
                            //             },
                            //           )),
                            //     )
                            //   ],
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.all(8),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await qrController?.pauseCamera();
                                      controller.isScanning.value = false;
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                          Colors.grey[300]!,
                                        ),
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.red)),
                                    child: const Text('Cancel',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.red)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
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
                                text: "Product",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18)),
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
                              enabled: controller.qcData.value == null,
                              selectedItem: controller.selectedProduct.value,
                              items: HomePageController.instance.productList
                                  .toList(),
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
                                text: "Gas",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18)),
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
                              enabled: controller.qcData.value == null,
                              items:
                                  HomePageController.instance.gasList.toList(),
                              itemAsString: (GasModel u) => u.gasName!,
                              selectedItem: controller.selectedGas.value,
                              onChanged: controller.setGasValue,
                              compareFn: (GasModel? item1, GasModel? item2) =>
                                  true,
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
                                    // onPressed: controller.qcData.value == null
                                    //     ? scanQrNormal
                                    //     : null,
                                    onPressed: () {
                                      if (controller.qcData.value == null) {
                                        controller.isScanning.value = true;
                                        qrController?.resumeCamera();
                                      }
                                    },

                                    // set qr code icon
                                    child: const Icon(Icons.qr_code),
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                          Colors.grey[300]!,
                                        ),
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.black)),
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
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                myText(
                                    text: "Is Testing",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18)),
                                SizedBox(
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
                            SizedBox(
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
                                            if (!formKey.currentState!
                                                .validate()) {
                                              LogUtil.warning(
                                                  'Please fill all the fields.');
                                              return;
                                            }

                                            if (controller.qcData.value ==
                                                null) {
                                              controller.updateSerial();
                                            } else {
                                              controller.updateQc();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            controller.qcData.value != null &&
                                    controller.qcData.value!.qc_rows!.isNotEmpty
                                ? Container(
                                    height: 600,
                                    child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: controller
                                          .qcData.value!.qc_rows!.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 65,
                                                  child: myText(
                                                      maxLines: 2,
                                                      text: controller
                                                          .qcData
                                                          .value!
                                                          .qc_rows![index]
                                                          .qc_name!,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16)),
                                                ),
                                                SizedBox(
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
                                                        // controller
                                                        //         .qcData
                                                        //         .value!
                                                        //         .qc_rows![index]
                                                        //         .qc_ok =
                                                        //     value.toString();

                                                        controller.handleQcChange(
                                                            value.toString(),
                                                            "qc_ok",
                                                            controller
                                                                    .qcData
                                                                    .value!
                                                                    .qc_rows![
                                                                index]);
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
                                                            controller
                                                                    .qcData
                                                                    .value!
                                                                    .qc_rows![
                                                                index]);
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
                                                            controller
                                                                    .qcData
                                                                    .value!
                                                                    .qc_rows![
                                                                index]);
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
                                            SizedBox(
                                              height: 10,
                                            ),
                                            controller
                                                        .qcData
                                                        .value!
                                                        .qc_rows![index]
                                                        .qc_ok ==
                                                    "No"
                                                ? DropdownSearch<ReasonModel>(
                                                    validator:
                                                        (ReasonModel? input) {
                                                      if (input?.reasonName ==
                                                          null) {
                                                        Get.snackbar('Warning',
                                                            'Select Reason',
                                                            colorText:
                                                                Colors.white,
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
                                                        .toList(),
                                                    itemAsString:
                                                        (ReasonModel u) =>
                                                            u.reasonName!,
                                                    onChanged:
                                                        (ReasonModel? value) {
                                                      controller.handleQcChange(
                                                          value!.reasonName!,
                                                          "qc_reason",
                                                          controller
                                                              .qcData
                                                              .value!
                                                              .qc_rows![index]);
                                                    },
                                                    compareFn:
                                                        (ReasonModel? item1,
                                                                ReasonModel?
                                                                    item2) =>
                                                            true,
                                                    popupProps: PopupProps.menu(
                                                      isFilterOnline: true,
                                                      showSearchBox: true,
                                                    ),
                                                  )
                                                : Container(),
                                            SizedBox(
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

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        // cutOutSize: scanArea
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController qrController) {
    qrController.scannedDataStream.listen((scanData) {
      // setState(() {
      //   result = scanData;
      //   _isScanning = false;
      //   _scanQrResult = scanData.code.toString();
      // });

      controller.code.value.text = scanData.code.toString();
      controller.isScanning.value = false;
      qrController.pauseCamera();
      qrController.resumeCamera();
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }
}
