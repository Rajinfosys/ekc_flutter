import 'package:get/get_rx/get_rx.dart';
import 'package:qr_code_scanner/core/utils/log_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/presentation/branding_sales/models/product_model.dart';
import 'package:qr_code_scanner/presentation/scan_serial/models/gas_model.dart';
import 'package:qr_code_scanner/presentation/scan_serial/models/reason_model.dart';
import '../repo/serial_repo.dart';

class ScanSerialController extends GetxController {
  Rx<TextEditingController> code = TextEditingController().obs;

  var isLoading = false.obs;
  var isEditLoading = false.obs;

  RxList<ProductModel> productList = RxList.empty();
  RxList<GasModel> gasList = RxList.empty();
  RxList<ReasonModel> reasonList = RxList.empty();
  Rx<ProductModel?> selectedProduct = Rx(null);
  Rx<GasModel?> selectedGas = Rx(null);
  Rx<ReasonModel?> selectedReason = Rx(null);

  static ScanSerialController get instance => Get.find<ScanSerialController>();

  getDdlData() async {
    try {
      isLoading.value = true;
      final result = await SerialRepo.getDdlData();
      productList.addAll(result.products);
      gasList.addAll(result.gases);
      reasonList.addAll(result.reasons);
    } catch (e) {
      LogUtil.error(e);
      Get.snackbar('Error', "$e");
    } finally {
      isLoading.value = false;
    }
  }

  void setProductValue(ProductModel? product) {
    selectedProduct.value = product;
  }

  void setGasValue(GasModel? gas) {
    selectedGas.value = gas;
  }

  @override
  void onInit() {
    getDdlData();

    super.onInit();
  }

  void clear() {
    code.value.clear();
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
