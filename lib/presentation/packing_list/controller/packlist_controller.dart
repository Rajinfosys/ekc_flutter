import 'dart:convert';

import 'package:ekc_scan/core/utils/log_util.dart';
import 'package:ekc_scan/core/utils/storage_util.dart';
import 'package:ekc_scan/presentation/auth/models/user_model.dart';
import 'package:ekc_scan/presentation/home_screen/controller/home_controller.dart';
import 'package:ekc_scan/presentation/home_screen/models/customer_model.dart';
import 'package:ekc_scan/presentation/home_screen/models/gas_model.dart';
import 'package:ekc_scan/presentation/home_screen/models/product_model.dart';
import 'package:ekc_scan/presentation/home_screen/models/serialno_model.dart';
import 'package:ekc_scan/presentation/packing_list/models/packlist_model.dart';
import 'package:ekc_scan/presentation/packing_list/partial_packing_list.dart';
import 'package:ekc_scan/presentation/scan_serial/models/serial_model.dart';
import 'package:ekc_scan/service/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/dialogs.dart';

class PacklistController extends GetxController {
  Rx<TextEditingController> code = TextEditingController().obs;
  RxBool isTesting = false.obs;
  RxBool isClientSr = false.obs;

  var isLoading = false.obs;
  var isEditLoading = false.obs;
  var isInitialized = false.obs;

  RxBool isScanning = false.obs;

  SerialModel? serial;

  Rx<ProductModel?> selectedProduct = Rx(null);
  Rx<GasModel?> selectedGas = Rx(null);
  Rx<PartyModel?> selectedParty = Rx(null);

  RxList<SerialNoModel> packSerialList = RxList.empty();

  Rx<TextEditingController> transaction_no = TextEditingController().obs;
  Rx<TextEditingController> valve_make = TextEditingController().obs;
  Rx<TextEditingController> packing = TextEditingController().obs;
  Rx<TextEditingController> valve_wp = TextEditingController().obs;
  Rx<TextEditingController> total_qty = TextEditingController().obs;
  Rx<TextEditingController> transaction_date = TextEditingController().obs;
  var actual_qty = 0.obs;

  RxList<PacklistModel> partialPackLists = RxList.empty();

  static PacklistController get instance => Get.find<PacklistController>();

  static const String _getCommonPath = '/api_qrcode/index.php';

  void addPackingList() async {
    try {
      var user = UserModel.fromJson(jsonDecode(StorageUtil.getUserData()!));

      Map<String, dynamic> data = {
        "dbtype": "savePackingList",
        "productid": selectedProduct.value!.productId,
        "gas_type": selectedGas.value!.gasName,
        "partyid": selectedParty.value!.partyid,
        "transaction_no": transaction_no.value.text,
        "valve_make": valve_make.value.text,
        "valve_wp": valve_wp.value.text,
        "actual_qty": packSerialList.length,
        "transaction_date": transaction_date.value.text,
        "serialList": packSerialList
            .where((p0) => p0.packlistdtlid == null)
            .map((e) => e.toJson())
            .toList(),
        "total_quantity": total_qty.value.text,
        "location_id": user.locationId,
        "user_id": user.login
      };

      var arguments = Get.arguments;
      var isEdit = false;
      if (arguments != null && arguments['isEdit'] == true) {
        isEdit = true;
        data['dbtype'] = "updatePackingList";
        data['packlistid'] = arguments['packlistid'];
      }

      LogUtil.debug(data);
      // return;
      isLoading(true);

      try {
        final result = await HttpService.post(_getCommonPath, data);

        if (result['status'] != 200) {
          Get.snackbar('Error', result['message']);
        } else {
          LogUtil.debug(result);
          if (isEdit) {
            // await getPackingList();
            Get.back(); // back to list screen
            Get.back(); // back to home screen
            Get.snackbar('Success', "Packing List Updated Successfully");

            // clear stack 2 times
            clear();
          } else {
            Dialogs.showSnackBar(
                Get.context, "Packing List Added Successfully");
            clear();
          }
        }
      } catch (e) {
        LogUtil.error(e);
        Get.snackbar('Error', "$e");
      }

      isLoading(false);
    } catch (e) {
      isLoading(false);
      Get.snackbar('Error', "$e");
    }
  }

  Future<void> getPackingList() async {
    try {
      var user = UserModel.fromJson(jsonDecode(StorageUtil.getUserData()!));

      Map<String, dynamic> data = {"dbtype": "getPackingLists"};
      isLoading(true);

      try {
        final result = await HttpService.post(_getCommonPath, data);
        partialPackLists = RxList<PacklistModel>.from(
            result['data'].map((e) => PacklistModel.fromJson(e)).toList());

        if (result['status'] != 200) {
          Get.snackbar('Error', result['message']);
        }
      } catch (e) {
        LogUtil.error(e);
        Get.snackbar('Error', "$e");
      }

      isLoading(false);
    } catch (e) {
      isLoading(false);
      Get.snackbar('Error', "$e");
    }
  }

  void setProductValue(ProductModel? product) {
    selectedProduct.value = product;
    packSerialList.clear();
  }

  void setGasValue(GasModel? gas) {
    selectedGas.value = gas;
    packSerialList.clear();
  }

  void setPartyValue(PartyModel? party) {
    selectedParty.value = party;
  }

  @override
  void onInit() async {
    var route = Get.currentRoute;
    LogUtil.debug(route);

    if (Get.currentRoute == PartialPackListView.routeName) {
      await getPackingList();
    } else {
      var today = DateTime.now();
      transaction_date.value.text = today.toString().split(' ')[0];
      clear();
    }

    isInitialized.value = true;

    super.onInit();
  }

  void getPacklistDetails(details) {
    if (details['is_client_sr'] != null) {
      isClientSr.value = details['is_client_sr'] == '1' ? true : false;
    }

    if (details['productid'] != null) {
      selectedProduct.value = HomePageController.instance.productList
          .toList()
          .firstWhere((element) => element.productId == details['productid']);
    }

    if (details['gas_type'] != null) {
      selectedGas.value = HomePageController.instance.gasList
          .toList()
          .firstWhere((element) => element.gasName == details['gas_type']);
    }

    if (details['party_id'] != null) {
      selectedParty.value = HomePageController.instance.partyList
          .toList()
          .firstWhere((element) => element.partyid == details['party_id']);
    }

    transaction_no.value.text = details['transaction_no'] ?? '';
    valve_make.value.text = details['valve_make'] ?? '';
    packing.value.text = details['packing'] ?? '';
    valve_wp.value.text = details['valve_wp'] ?? '';

    total_qty.value.text = details['total_quantity'] ?? 0;

    if (details['transaction_date'] != null) {
      transaction_date.value.text =
          details['transaction_date'].toString().split(" ")[0];
    }

    if (details['serialList'] != null) {
      var serialList = details['serialList'];

      packSerialList = RxList<SerialNoModel>.from(serialList);
    }
  }

  void clear() {
    code.value.clear();

    transaction_no.value.clear();
    valve_make.value.clear();
    packing.value.clear();
    valve_wp.value.clear();
    total_qty.value.clear();

    var today = DateTime.now();
    transaction_date.value.text = today.toString().split(' ')[0];
    packSerialList.clear();
    selectedProduct.value = null;
    selectedGas.value = null;
    selectedParty.value = null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    code.value.dispose();
  }
}
