import 'package:get_storage/get_storage.dart';
import 'package:qr_code_scanner/core/utils/dialogs.dart';
import 'package:qr_code_scanner/core/utils/global_variables.dart';
import 'package:qr_code_scanner/core/utils/log_util.dart';
import 'package:qr_code_scanner/presentation/home_screen/controller/home_controller.dart';
import 'package:qr_code_scanner/presentation/home_screen/models/customer_model.dart';
import 'package:qr_code_scanner/presentation/home_screen/models/gas_model.dart';
import 'package:qr_code_scanner/presentation/home_screen/models/product_model.dart';
import 'package:qr_code_scanner/presentation/home_screen/models/reason_model.dart';
import 'package:qr_code_scanner/presentation/home_screen/models/serialno_model.dart';
import 'package:qr_code_scanner/presentation/packing_list/controller/packlist_controller.dart';
import 'package:qr_code_scanner/presentation/scan_serial/controller/serial_controller.dart';
import 'package:qr_code_scanner/widgets/general_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';

import '../../core/utils/app_color.dart';

class PackListView extends GetView<PacklistController> {
  PackListView({Key? key}) : super(key: key);
  static const routeName = '/packing-list';
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

    // add scanned qr code to the packSerialList
    if (qrScanRes != '-1') {
      var serial = HomePageController.instance.serialList
          .firstWhere((element) => element.serialno == qrScanRes);

      if (serial == null ||
          controller.selectedProduct.value?.productId != serial.productid ||
          controller.selectedGas.value?.gasName != serial.gas_type) {
        Get.snackbar('Warning', 'Invalid Serial No.',
            colorText: Colors.white, backgroundColor: Colors.blue);
        return;
      }

      if (controller.packSerialList
          .any((element) => element.serialno == qrScanRes)) {
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
        controller.transaction_date.value.text =
            _picked.toString().split(" ")[0];
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarWidget(
        title: "Packing List",
        leading: const Icon(CupertinoIcons.arrow_left),
      ),
      body: Obx(() => !controller.isInitialized.value
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
                          items:
                              HomePageController.instance.productList.toList(),
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
                          items: HomePageController.instance.gasList.toList(),
                          itemAsString: (GasModel u) => u.gasName!,
                          onChanged: controller.setGasValue,
                          compareFn: (GasModel? item1, GasModel? item2) => true,
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
                          items: HomePageController.instance.partyList.toList(),
                          selectedItem: controller.selectedParty.value,
                          itemAsString: (PartyModel u) => u.fullname!,
                          onChanged: controller.setPartyValue,
                          compareFn: (PartyModel? item1, PartyModel? item2) =>
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
                        ),
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
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        myTextField(
                          text: "Valve Make",
                          controller: controller.valve_make.value,
                          validator: (String input) {
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        myTextField(
                          text: "Valve WP",
                          controller: controller.valve_wp.value,
                          validator: (String input) {
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        myTextField(
                          text: "Packing",
                          controller: controller.packing.value,
                          validator: (String input) {
                            return null;
                          },
                        ),
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
                                  controller.packSerialList.length.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
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
                                    element.serialno == item.serialno);
                          }).toList(),
                          selectedItem: null,
                          itemAsString: (SerialNoModel u) => u.serialno!,
                          onChanged: (SerialNoModel? value) {
                            if (controller.total_qty.value.text.isEmpty) {
                              Get.snackbar(
                                  'Warning', 'Please Specify Total Qty');
                              return;
                            }

                            if (controller.packSerialList.length >=
                                int.parse(controller.total_qty.value.text)) {
                              Get.snackbar('Warning', 'Total qty limit reached',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.blue);
                              return;
                            }
                            if (value != null) {
                              controller.packSerialList.add(value);
                            }
                          },
                          compareFn:
                              (SerialNoModel? item1, SerialNoModel? item2) =>
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

                                scanQrNormal();
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
                                      borderRadius: BorderRadius.circular(3),
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
                                    title: Text(controller
                                            .packSerialList[index].serialno! +
                                        " (wt : " +
                                        controller
                                            .packSerialList[index].tar_weight
                                            .toString() +
                                        ")"),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        controller.packSerialList
                                            .removeAt(index);
                                      },
                                    ),
                                    // give background color
                                    tileColor: Colors.grey[200],
                                    // give bottom border
                                    shape: const Border(
                                      bottom: BorderSide(color: Colors.grey),
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
                                  child: CircularProgressIndicator(),
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

                                        if (int.parse(controller
                                                .total_qty.value.text) <=
                                            controller.packSerialList.length) {
                                          Get.snackbar('Warning',
                                              'Total qty cannot be less than actual qty',
                                              colorText: Colors.white,
                                              backgroundColor: Colors.blue);
                                          return;
                                        }

                                        if (controller.packSerialList.isEmpty) {
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
}
