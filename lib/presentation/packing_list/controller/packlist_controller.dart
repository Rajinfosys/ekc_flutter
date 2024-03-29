import 'package:get/get_rx/get_rx.dart';
import 'package:qr_code_scanner/core/utils/log_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/presentation/home_screen/models/customer_model.dart';
import 'package:qr_code_scanner/presentation/home_screen/models/gas_model.dart';
import 'package:qr_code_scanner/presentation/home_screen/models/product_model.dart';
import 'package:qr_code_scanner/presentation/home_screen/models/reason_model.dart';
import 'package:qr_code_scanner/presentation/home_screen/models/serialno_model.dart';
import 'package:qr_code_scanner/presentation/scan_serial/models/qc_model.dart';
import 'package:qr_code_scanner/presentation/scan_serial/models/serial_model.dart';
import 'package:qr_code_scanner/service/http_service.dart';
import '../../../core/utils/dialogs.dart';

class PacklistController extends GetxController {
  Rx<TextEditingController> code = TextEditingController().obs;
  RxBool isTesting = false.obs;

  var isLoading = false.obs;
  var isEditLoading = false.obs;
  var isInitialized = false.obs;

  SerialModel? serial;

  Rx<ProductModel?> selectedProduct = Rx(null);
  Rx<GasModel?> selectedGas = Rx(null);
  Rx<PartyModel?> selectedParty = Rx(null);

  RxList<SerialNoModel> packSerialList = RxList.empty();

//   {
//     "transaction_date": "2024-03-29",
//     "transaction_no": "100",
//     "valve_make": "123",
//     "packing": "100",
//     "valve_wp": "123",
//     "actual_qty": "5",
//     "dbtype": "savePackingList",
//     "partyid": 1,
//     "total_quantity": 2,
//     "serialList": [
//         {
//             "serialno": "0224#B2K120C25397",
//             "gas_type": "HE",
//             "batchid": 13722,
//             "productid": 242,
//             "tar_weight": "10.00"
//         },
//         {
//             "serialno": "0224#B2K120C25400",
//             "gas_type": "HE",
//             "batchid": 13723,
//             "productid": 242,
//             "tar_weight": ".00"
//         }
//     ],
//     "productid": 242,
//     "gas_type": "HE"
// }

  Rx<TextEditingController> transaction_no = TextEditingController().obs;
  Rx<TextEditingController> valve_make = TextEditingController().obs;
  Rx<TextEditingController> packing = TextEditingController().obs;
  Rx<TextEditingController> valve_wp = TextEditingController().obs;
  Rx<TextEditingController> total_qty = TextEditingController().obs;
  Rx<TextEditingController> transaction_date = TextEditingController().obs;
  var actual_qty = 0.obs;

  static PacklistController get instance => Get.find<PacklistController>();

  static const String _getCommonPath = '/api_qrcode/index.php';

  void addPackingList() async {
    try {
      Map<String, dynamic> data = {
        "dbtype": "savePackingList",
        "productid": selectedProduct.value!.productId,
        "gas_type": selectedGas.value!.gasName,
        "transaction_no": transaction_no.value.text,
        "valve_make": valve_make.value.text,
        "valve_wp": valve_wp.value.text,
        "actual_qty": total_qty.value.text,
        "transaction_date": transaction_date.value.text,
        "serialList": packSerialList.map((e) => e.toJson()).toList(),
        "total_quantity": packSerialList.length,
      };

      LogUtil.debug(data);
      // return;
      isLoading(true);

      try {
        final result = await HttpService.post(_getCommonPath, data);

        if (result['status'] != 200) {
          Get.snackbar('Error', result['message']);
        } else {
          LogUtil.debug(result);
          Dialogs.showSnackBar(Get.context, "Packing List Added Successfully");
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
    // if (!isInitialized.value) await getDdlData();

    isInitialized.value = true;

    var today = DateTime.now();
    transaction_date.value.text = today.toString().split(' ')[0];
    code.value.text = '0224#B2K120C25397';
    isTesting.value = false;
    super.onInit();
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
