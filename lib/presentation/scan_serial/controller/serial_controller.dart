import 'dart:convert';

import 'package:ekc_scan/core/utils/log_util.dart';
import 'package:ekc_scan/core/utils/storage_util.dart';
import 'package:ekc_scan/presentation/auth/models/user_model.dart';
import 'package:ekc_scan/presentation/home_screen/models/gas_model.dart';
import 'package:ekc_scan/presentation/home_screen/models/product_model.dart';
import 'package:ekc_scan/presentation/home_screen/models/reason_model.dart';
import 'package:ekc_scan/presentation/scan_serial/models/qc_model.dart';
import 'package:ekc_scan/presentation/scan_serial/models/serial_model.dart';
import 'package:ekc_scan/service/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/dialogs.dart';

class ScanSerialController extends GetxController {
  Rx<TextEditingController> code = TextEditingController().obs;
  RxBool isTesting = false.obs;
  RxBool isClientSr = false.obs;


  var flashOn = false.obs;

  var isLoading = false.obs;
  var isEditLoading = false.obs;
  var isInitialized = false.obs;

  RxBool isScanning = false.obs;

  SerialModel? serial;

  Rx<ProductModel?> selectedProduct = Rx(null);
  Rx<GasModel?> selectedGas = Rx(null);
  Rx<ReasonModel?> selectedReason = Rx(null);

  Rx<QcModel?> qcData = Rx(null);

  static ScanSerialController get instance => Get.find<ScanSerialController>();

  //static const String _getCommonPath = '/scriptcase/app/ekc_qc/api_qrcode/index.php';
  static const String _getCommonPath = '/api_qrcode/index.php';
  void updateSerial() async {
    try {
      var user = UserModel.fromJson(jsonDecode(StorageUtil.getUserData()!));

      Map<String, dynamic> data = {
        "dbtype": "updateSerialno",
        "productid": selectedProduct.value!.productId,
        "gas": selectedGas.value!.gasName,
        "code": code.value.text,
        "isTesting": isTesting.value ? 1 : 0,
        "location_id": user.locationId,
        "user_id": user.login,
        "is_client_sr": isClientSr.value ? true : false
      };
      LogUtil.debug(data);

      isLoading(true);

      try {
        final result = await HttpService.post(_getCommonPath, data);

        if (result['status'] != 200) {
          Get.snackbar('Error', result['message']);
        } else {
          LogUtil.debug(result);
          Dialogs.showSnackBar(Get.context, "Serial No. updated");

          if (!isTesting.value) {
            // set qcData as result['data']
            qcData.value = QcModel.fromJson(result['data']);

            // for each qc row in qc data set qc_ok as "Yes"
            for (var element in qcData.value!.qc_rows!) {
              element.qc_ok = element.qc_ok ?? "Yes";
            }
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

  void updateQc() async {
    try {
      // for (let i = 0; i < qcData.qc_rows.length; i++) {
      //   const element = qcData.qc_rows[i];
      //   if (!element.qc_ok) {
      //     toast.error("Please select QC status for all fields");
      //     return;
      //   }
      // }

      for (var i = 0; i < qcData.value!.qc_rows!.length; i++) {
        final element = qcData.value!.qc_rows![i];
        if (element.qc_ok == null) {
          // show red snackbar
          Get.snackbar('Error', "Please select QC status for all fields",
              backgroundColor: Colors.red);
          return;
        }
      }

      var user = UserModel.fromJson(jsonDecode(StorageUtil.getUserData()!));

      Map<String, dynamic> data = {
        "dbtype": "updateQc",
        "qcid": qcData.value!.qcid,
        "batchid": qcData.value!.batchid,
        "qc_rows": qcData.value!.qc_rows!.map((e) => e.toJson()).toList(),
        "code": code.value.text,
        "location_id": user.locationId,
        "user_id": user.login,
        "is_client_sr": isClientSr.value ? true : false
      };

      isLoading(true);
      try {
        final result = await HttpService.post(_getCommonPath, data);

        if (result['status'] != 200) {
          Get.snackbar('Error', result['message']);
        } else {
          LogUtil.debug(result);
          Dialogs.showSnackBar(Get.context, "QC updated");
          clear();
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
  }

  void setGasValue(GasModel? gas) {
    selectedGas.value = gas;
  }

  void handleQcChange(String val, String type, QcRowModel qcRow) {
    List<QcRowModel> temp = qcData.value!.qc_rows!;
    final idx = temp.indexWhere((x) => x.qcdtlid == qcRow.qcdtlid);
    if (type == 'qc_ok') {
      temp[idx].qc_ok = val;
    } else {
      temp[idx].qc_reason = val;
    }
    qcData.value = QcModel(
        qcid: qcData.value!.qcid,
        batchid: qcData.value!.batchid,
        qc_rows: temp);
  }

  @override
  void onInit() async {
    // if (!isInitialized.value) await getDdlData();

    isInitialized.value = true;
    // code.value.text = '0224#B2K120C25397';
    isTesting.value = false;
    super.onInit();
  }

  void clear() {
    isClientSr.value = false;
    code.value.clear();
    qcData.value = null;
    selectedProduct.value = null;
    selectedGas.value = null;
    selectedReason.value = null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    code.value.dispose();
  }
}
