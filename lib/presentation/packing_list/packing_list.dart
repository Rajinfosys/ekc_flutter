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

// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';

import '../../core/utils/app_color.dart';
import '../qrscanner/controller/qr_scanner_controller.dart';

class PackListView extends GetView<PacklistController> {
  PackListView({Key? key}) : super(key: key);
  static const routeName = '/packing-list';
  final formKey = GlobalKey<FormState>();

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

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
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextButton(
              onPressed: () async {
                Get.defaultDialog(
                  title: "Confirmation",
                  titleStyle: const TextStyle(color: Colors.green),
                  content: const Text(
                    "Do you want to sync the data?",
                    textAlign: TextAlign.center,
                  ),
                  confirm: GestureDetector(
                    onTap: () async {
                      controller.isFetchingData.value = true;

                      await HomePageController.instance.getDdlData();
                      controller.isFetchingData.value = false;
                      Get.back();
                      Get.snackbar(
                        'Success',
                        "Data Synced Successfully",
                        backgroundColor: AppColors.green,
                      );
                    },
                    child: Obx(
                      () => controller.isFetchingData.value
                          ? const CircularProgressIndicator()
                          : Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              width: double.infinity,
                              // Makes the container full width
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.green, // Button background color
                                borderRadius: BorderRadius.circular(20),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'YES',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                    ),
                  ),
                  cancel: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      // Makes the container full width
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.red, // Button background color
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'NO',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                );
              },
              child: const Text('Refresh'),
            ),
          ),
        ],
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
                                onChanged: (bool value) {
                                  controller.isClientSr.value = value;
                                }),
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
                          // enabled: !isEdit,
                          items: HomePageController.instance.productList.map<DropdownMenuItem<ProductModel>>(
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
                          // selectedItem: controller.selectedProduct.value,
                          /*compareFn:
                              (ProductModel? item1, ProductModel? item2) =>
                                  true,
                          popupProps: const PopupProps.menu(
                            isFilterOnline: true,
                            showSearchBox: true,
                          ),*/
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
                          // enabled: !isEdit,
                          items: HomePageController.instance.gasList.map<DropdownMenuItem<GasModel>>(
                                  (GasModel? value) {
                                return DropdownMenuItem<GasModel>(
                                  value: value,
                                  child: Text(
                                    '${value?.gasName}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                          // itemAsString: (GasModel u) => u.gasName!,
                          onChanged: controller.setGasValue,
                          // compareFn: (GasModel? item1, GasModel? item2) => true,
                          // selectedItem: controller.selectedGas.value,
                          // popupProps: const PopupProps.menu(
                          //   isFilterOnline: true,
                          //   showSearchBox: true,
                          // ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        myText(
                            text: "Party",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18)),
                        SizedBox(
                          height: Get.height * dropSize,
                        ),
                        DropdownButtonFormField<PartyModel>(
                          validator: (PartyModel? input) {
                            if (input?.fullname == null) {
                              Get.snackbar('Warning', 'Select Party',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.blue);
                              return '';
                            }
                            return null;
                          },
                          // enabled: !isEdit,
                          items: HomePageController.instance.partyList.map<DropdownMenuItem<PartyModel>>(
                                                            (PartyModel? value) {
                                                          return DropdownMenuItem<PartyModel>(
                                                            value: value,
                                                            child: Text(
                                                              '${value?.fullname}',
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          );
                                                        }).toList(),
                          // selectedItem: controller.selectedParty.value,
                          // itemAsString: (PartyModel u) => u.fullname!,
                          onChanged: controller.setPartyValue,
                          // compareFn: (PartyModel? item1, PartyModel? item2) =>
                          //     true,
                          // popupProps: const PopupProps.menu(
                          //   isFilterOnline: true,
                          //   showSearchBox: true,
                          // ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        myTextField(
                            text: "Invoice No.",
                            controller: controller.transaction_no.value,
                            validator: (String input) {
                              return null;
                            },
                            enabled: !isEdit),
                        const SizedBox(
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
                        const SizedBox(
                          height: 10,
                        ),
                        myTextField(
                            text: "Valve Make",
                            controller: controller.valve_make.value,
                            validator: (String input) {
                              return null;
                            },
                            enabled: !isEdit),
                        const SizedBox(
                          height: 10,
                        ),
                        myTextField(
                            text: "Valve WP",
                            controller: controller.valve_wp.value,
                            validator: (String input) {
                              return null;
                            },
                            enabled: !isEdit),
                        const SizedBox(
                          height: 10,
                        ),
                        myTextField(
                            text: "Packing",
                            controller: controller.packing.value,
                            validator: (String input) {
                              return null;
                            },
                            enabled: !isEdit),
                        const SizedBox(
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
                                  if (input == '') {}
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  return;
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            myText(
                              text:
                                  "Actual Qty : ${controller.packSerialList.length}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(
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
                        const SizedBox(
                          height: 5,
                        ),

                        Obx(
                              () => CheckboxListTile(
                            title: const Text("Manual Entry"),
                            value: controller.isManual.value,
                            onChanged: (bool? value) {
                              if (value != null) {
                                controller.isManual.value = value;
                              }
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero, // Remove extra padding
                          ),
                        ),

                        Row(
                          children: [
                            Expanded(
                              flex: 7,
                              child: DropdownSearch<SerialNoModel>(
                                // asyncItems: (String? filter) async {
                                //   final serialList = HomePageController
                                //       .instance.serialList
                                //       .where((item) {
                                //     return item.productid ==
                                //             controller.selectedProduct.value
                                //                 ?.productId &&
                                //         item.gas_type ==
                                //             controller
                                //                 .selectedGas.value?.gasName &&
                                //         !controller.packSerialList.any(
                                //             (element) =>
                                //                 (element.serialno ==
                                //                     item.serialno) &&
                                //                 (element.client_serialno ==
                                //                     item.client_serialno));
                                //   }).toList();
                                //
                                //   if (filter == null || filter.isEmpty) {
                                //     return serialList;
                                //   } else {
                                //     final matches = serialList.where((item) {
                                //       return controller.isClientSr.value
                                //           ? item.client_serialno!
                                //               .contains(filter)
                                //           : item.serialno!.contains(filter);
                                //     }).toList();
                                //
                                //     if (matches.isNotEmpty) {
                                //       return matches;
                                //     } else if (controller
                                //         .okButtonPressed.value || !controller.isManual.value) {
                                //       controller.handleOkButtonClick(filter);
                                //       return [];
                                //     }
                                //     return [];
                                //   }
                                // },
                                selectedItem: null,
                                itemAsString: (SerialNoModel u) =>
                                    controller.isClientSr.value
                                        ? u.client_serialno!
                                        : u.serialno!,
                                onChanged: (SerialNoModel? value) {
                                  if (value != null) {
                                    value.packlistdtlid = null;
                                    controller.packSerialList.add(value);
                                  }
                                },
                                compareFn: (SerialNoModel? item1,
                                        SerialNoModel? item2) =>
                                    true,
                                popupProps: PopupProps.menu(
                                  // isFilterOnline: true,
                                  showSearchBox: true,
                                  searchFieldProps: TextFieldProps(
                                    controller: controller.searchController,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Obx(
                              () => controller.isManual.value ? Expanded(
                                flex: 2,
                                child: ElevatedButton(
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
                                  onPressed: () {
                                    final filter =
                                        controller.searchController.text.trim();
                                    if (filter.isEmpty) {
                                      Get.snackbar(
                                        'Warning',
                                        'Please enter a valid code',
                                        colorText: Colors.white,
                                        backgroundColor: Colors.red,
                                      );
                                      return;
                                    }
                                    controller.handleOkButtonClick(
                                        filter); // Handle OK logic
                                  },
                                  child: Obx(() =>
                                      !controller.okButtonPressed.value
                                          ? const Text("OK")
                                          : const CircularProgressIndicator()),
                                ),
                              ) : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 30,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                // controller.code.value.text = '';
                                // checker();
                                if (controller.total_qty.value.text == '' ||
                                    controller.total_qty.value.text == '0') {
                                  Get.snackbar(
                                      'Warning', 'Please Specify Total Qty');
                                  return;
                                }

                                if (controller.selectedProduct.value == null ||
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

                                QRScannerController.instance
                                    .openQrScannerScreen('packlist');
                                /*SerialNoModel? tempSrNo;
                                  try{
                                    tempSrNo = HomePageController
                                        .instance.serialList
                                        .firstWhere((item) =>
                                    item.serialno ==
                                        controller.code.value.text);
                                    if (tempSrNo != null) {
                                      LogUtil.debug(tempSrNo.toJson());
                                      if (!controller.packSerialList
                                          .contains(controller.code.value.text)) {
                                        controller.packSerialList.add(tempSrNo);
                                      }
                                      else{
                                        Get.snackbar('Warning', 'Serial no. already contains!!',
                                            colorText: Colors.white,
                                            backgroundColor: Colors.blue);
                                      }
                                    }
                                    else{
                                      Get.snackbar('Warning', 'Invalid Serial No.',
                                          colorText: Colors.white,
                                          backgroundColor: Colors.blue);
                                    }
                                  }catch(e){
                                    LogUtil.debug(e.toString());
                                  }*/
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
                              child: const Row(
                                children: [
                                  Icon(Icons.qr_code),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text('Scan QR'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 250,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Obx(
                            () => ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: controller.packSerialList.length,
                              itemBuilder: (context, index) {
                                return Card(
                                    margin: EdgeInsets.zero,
                                    child: ListTile(
                                      title: Text(
                                          "${controller.isClientSr.value == true ? controller.packSerialList[index].client_serialno! : controller.packSerialList[index].serialno!} (wt : ${controller.packSerialList[index].tar_weight})"),
                                      trailing: controller.packSerialList[index]
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
                                        bottom: BorderSide(color: Colors.grey),
                                      ),
                                    ));
                              },
                            ),
                          ),
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

/*
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

*/
}
