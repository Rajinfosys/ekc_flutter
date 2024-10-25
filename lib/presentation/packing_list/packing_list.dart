import 'package:dropdown_search/dropdown_search.dart';
import 'package:ekc_scan/core/utils/global_variables.dart';
import 'package:ekc_scan/core/utils/log_util.dart';
import 'package:ekc_scan/presentation/home_screen/controller/home_controller.dart';
import 'package:ekc_scan/presentation/home_screen/models/customer_model.dart';
import 'package:ekc_scan/presentation/home_screen/models/gas_model.dart';
import 'package:ekc_scan/presentation/home_screen/models/product_model.dart';
import 'package:ekc_scan/presentation/home_screen/models/serialno_model.dart';
import 'package:ekc_scan/presentation/packing_list/controller/packlist_controller.dart';
import 'package:ekc_scan/widgets/general_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../core/utils/app_color.dart';

class PackListView extends GetView<PacklistController> {
  PackListView({Key? key}) : super(key: key);
  static const routeName = '/packing-list';
  final formKey = GlobalKey<FormState>();

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrController;
  ScrollController scrollController = new ScrollController();

  Future<void> scanQrNormal() async {
    String qrScanRes;
    try {
      qrScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      debugPrint(qrScanRes);
    } on PlatformException {
      qrScanRes = 'Failed to get platform version.';
    }

    // add scanned qr code to the packSerialList
    if (qrScanRes != '-1') {
      var serial = HomePageController.instance.serialList.firstWhereOrNull(
          (element) => (element.serialno == qrScanRes ||
              element.client_serialno == qrScanRes));

      if (serial == null ||
          controller.selectedProduct.value?.productId != serial.productid ||
          controller.selectedGas.value?.gasName != serial.gas_type) {
        Get.snackbar('Warning', 'Invalid Serial No.',
            colorText: Colors.white, backgroundColor: Colors.blue);
        return;
      }

      if (controller.packSerialList.any((element) =>
          (element.serialno == qrScanRes ||
              element.client_serialno == qrScanRes))) {
        Get.snackbar('Warning', 'Serial No. already added.',
            colorText: Colors.white, backgroundColor: Colors.blue);
        return;
      }

      controller.packSerialList.add(serial);
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _selectDate() async {
      DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (_picked != null) {
        var temp = _picked.toString().split(" ")[0];
        controller.transaction_date.value.text =
            _picked.toString().split(" ")[0];
      }
    }

    // get arguments
    var args = Get.arguments;
    var isEdit = false;
    if (args != null && args['isEdit'] == true) {
      isEdit = true;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarWidget(
        title: "Packing List",
        leading: const Icon(CupertinoIcons.arrow_left),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(bottom: 50.0, right: 16),
      //   child: FloatingActionButton(
      //     onPressed: () async {
      //       scrollController?.animateTo(
      //         1500.0,
      //         duration: const Duration(milliseconds: 500),
      //         curve: Curves.easeOut,
      //       );
      //     },
      //     backgroundColor: AppColors.white2,
      //     child: const Icon(CupertinoIcons.arrow_down, color: AppColors.green),
      //   ),
      // ),
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
                                      // set timeout
                                      Future.delayed(
                                        const Duration(milliseconds: 500),
                                        () {
                                          scrollController?.jumpTo(
                                            scrollController
                                                .position.maxScrollExtent,
                                          );
                                        },
                                      );
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
                                        style: TextStyle(fontSize: 20)),
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
                  controller: scrollController,
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
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18)),
                                SizedBox(
                                  width: 25,
                                ),
                                Switch(
                                    // This bool value toggles the switch.
                                    value: controller.isClientSr.value,
                                    activeColor: Colors.green,
                                    onChanged: (bool value) {
                                      controller.isClientSr.value = value;
                                    }),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
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
                              enabled: !isEdit,
                              items: HomePageController.instance.productList
                                  .toList(),
                              itemAsString: (ProductModel u) => u.productName!,
                              onChanged: controller.setProductValue,
                              selectedItem: controller.selectedProduct.value,
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
                              enabled: !isEdit,
                              items:
                                  HomePageController.instance.gasList.toList(),
                              itemAsString: (GasModel u) => u.gasName!,
                              onChanged: controller.setGasValue,
                              compareFn: (GasModel? item1, GasModel? item2) =>
                                  true,
                              selectedItem: controller.selectedGas.value,
                              popupProps: PopupProps.menu(
                                isFilterOnline: true,
                                showSearchBox: true,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            myText(
                                text: "Party",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18)),
                            SizedBox(
                              height: Get.height * dropSize,
                            ),
                            DropdownSearch<PartyModel>(
                              validator: (PartyModel? input) {
                                if (input?.fullname == null) {
                                  Get.snackbar('Warning', 'Select Party',
                                      colorText: Colors.white,
                                      backgroundColor: Colors.blue);
                                  return '';
                                }
                                return null;
                              },
                              enabled: !isEdit,
                              items: HomePageController.instance.partyList
                                  .toList(),
                              selectedItem: controller.selectedParty.value,
                              itemAsString: (PartyModel u) => u.fullname!,
                              onChanged: controller.setPartyValue,
                              compareFn:
                                  (PartyModel? item1, PartyModel? item2) =>
                                      true,
                              popupProps: PopupProps.menu(
                                isFilterOnline: true,
                                showSearchBox: true,
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            myTextField(
                                text: "Invoice No.",
                                controller: controller.transaction_no.value,
                                validator: (String input) {
                                  return null;
                                },
                                enabled: !isEdit),
                            SizedBox(
                              height: 10,
                            ),
                            myTextField(
                                text: "Invoice Date",
                                controller: controller.transaction_date.value,
                                textInputType: TextInputType.datetime,
                                readOnly: true,
                                onTap: () {
                                  _selectDate();
                                },
                                prefixIcon: "assets/images/calendar-icon.png",
                                validator: (String input) {
                                  return null;
                                },
                                enabled: !isEdit),
                            SizedBox(
                              height: 10,
                            ),
                            myTextField(
                                text: "Valve Make",
                                controller: controller.valve_make.value,
                                validator: (String input) {
                                  return null;
                                },
                                enabled: !isEdit),
                            SizedBox(
                              height: 10,
                            ),
                            myTextField(
                                text: "Valve WP",
                                controller: controller.valve_wp.value,
                                validator: (String input) {
                                  return null;
                                },
                                enabled: !isEdit),
                            SizedBox(
                              height: 10,
                            ),
                            myTextField(
                                text: "Packing",
                                controller: controller.packing.value,
                                validator: (String input) {
                                  return null;
                                },
                                enabled: !isEdit),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: myTextField(
                                    text: "Total Qty",
                                    controller: controller.total_qty.value,
                                    textInputType: TextInputType.number,
                                    validator: (String input) {
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                myText(
                                  text: "Actual Qty" +
                                      " : " +
                                      controller.packSerialList.length
                                          .toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            myText(
                              text: "Add Serial No.",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            DropdownSearch<SerialNoModel>(
                              items: HomePageController.instance.serialList
                                  .where((item) {
                                return item.productid ==
                                        controller
                                            .selectedProduct.value?.productId &&
                                    item.gas_type ==
                                        controller.selectedGas.value?.gasName &&
                                    !controller.packSerialList.any((element) =>
                                        (element.serialno == item.serialno) &&
                                        (element.client_serialno ==
                                            item.client_serialno));
                              }).toList(),
                              selectedItem: null,
                              itemAsString: (SerialNoModel u) =>
                                  controller.isClientSr == true
                                      ? u.client_serialno!
                                      : u.serialno!,
                              onChanged: (SerialNoModel? value) {
                                if (controller.total_qty.value.text.isEmpty) {
                                  Get.snackbar(
                                      'Warning', 'Please Specify Total Qty');
                                  return;
                                }

                                if (controller.packSerialList.length >=
                                    int.parse(
                                        controller.total_qty.value.text)) {
                                  Get.snackbar(
                                      'Warning', 'Total qty limit reached',
                                      colorText: Colors.white,
                                      backgroundColor: Colors.blue);
                                  return;
                                }
                                if (value != null) {
                                  value.packlistdtlid = null;
                                  controller.packSerialList.add(value);
                                }
                              },
                              compareFn: (SerialNoModel? item1,
                                      SerialNoModel? item2) =>
                                  true,
                              popupProps: PopupProps.menu(
                                isFilterOnline: true,
                                showSearchBox: true,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 30,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (controller
                                        .total_qty.value.text.isEmpty) {
                                      Get.snackbar('Warning',
                                          'Please Specify Total Qty');
                                      return;
                                    }

                                    if (controller.selectedProduct.value ==
                                            null ||
                                        controller.selectedGas.value == null) {
                                      Get.snackbar(
                                        'Warning',
                                        'Select Product and Gas',
                                      );
                                      return;
                                    }

                                    if (controller.packSerialList.length >=
                                        int.parse(
                                            controller.total_qty.value.text)) {
                                      Get.snackbar(
                                        'Warning',
                                        'Total qty limit reached',
                                      );
                                      return;
                                    }

                                    // scanQrNormal();
                                    controller.isScanning.value = true;
                                    qrController?.resumeCamera();
                                  },
                                  // set qr code icon
                                  child: Row(
                                    children: const [
                                      Icon(Icons.qr_code),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text('Scan QR'),
                                    ],
                                  ),
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
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 250,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: controller.packSerialList.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                      margin: EdgeInsets.zero,
                                      child: ListTile(
                                        title: Text(
                                            (controller.isClientSr == true
                                                    ? controller
                                                        .packSerialList[index]
                                                        .client_serialno!
                                                    : controller
                                                        .packSerialList[index]
                                                        .serialno!) +
                                                " (wt : " +
                                                controller.packSerialList[index]
                                                    .tar_weight
                                                    .toString() +
                                                ")"),
                                        trailing: controller
                                                    .packSerialList[index]
                                                    .packlistdtlid ==
                                                null
                                            ? IconButton(
                                                icon: const Icon(Icons.delete),
                                                onPressed: () {
                                                  controller.packSerialList
                                                      .removeAt(index);
                                                },
                                              )
                                            : null,
                                        // give background color
                                        tileColor: Colors.grey[200],
                                        // give bottom border
                                        shape: const Border(
                                          bottom:
                                              BorderSide(color: Colors.grey),
                                        ),
                                      ));
                                },
                              ),
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

                                            // if (int.parse(controller
                                            //         .total_qty.value.text) <=
                                            //     controller
                                            //         .packSerialList.length) {
                                            //   Get.snackbar('Warning',
                                            //       'Total qty cannot be less than actual qty',
                                            //       colorText: Colors.white,
                                            //       backgroundColor: Colors.blue);
                                            //   return;
                                            // }

                                            if (controller
                                                .packSerialList.isEmpty) {
                                              Get.snackbar(
                                                  'Warning', 'Add Serial No.',
                                                  colorText: Colors.white,
                                                  backgroundColor: Colors.blue);
                                              return;
                                            }

                                            controller.addPackingList();
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

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = 300.0;

    // adjust scan area for tablet
    if (MediaQuery.of(context).size.width > 600) {
      scanArea = 500.0;
    }
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
          cutOutSize: scanArea),
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
      controller.isScanning.value = false;
      qrController.pauseCamera();

      Future.delayed(
        const Duration(milliseconds: 500),
        () {
          scrollController?.jumpTo(
            scrollController.position.maxScrollExtent,
          );
        },
      );

      var qrScanRes = scanData?.code?.toString();
      if (qrScanRes != null) {
        var serial = HomePageController.instance.serialList.firstWhereOrNull(
            (element) =>
                element.serialno == qrScanRes ||
                element.client_serialno == qrScanRes);

        if (serial == null ||
            controller.selectedProduct.value?.productId != serial.productid ||
            controller.selectedGas.value?.gasName != serial.gas_type) {
          Get.snackbar('Warning', 'Invalid Serial No.',
              colorText: Colors.white, backgroundColor: Colors.blue);
          qrScanRes = '';
          return;
        }

        if (controller.packSerialList.any((element) =>
            element.serialno == qrScanRes ||
            element.client_serialno == qrScanRes)) {
          Get.snackbar('Warning', 'Serial No. already added.',
              colorText: Colors.white, backgroundColor: Colors.blue);
          qrScanRes = '';
          return;
        }
        serial.packlistdtlid = null;
        controller.packSerialList.add(serial);
        qrScanRes = '';
      }
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
