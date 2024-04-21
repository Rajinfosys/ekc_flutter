import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ekc_scan/core/utils/log_util.dart';
import 'package:ekc_scan/presentation/home_screen/models/customer_model.dart';
import 'package:ekc_scan/presentation/home_screen/models/gas_model.dart';
import 'package:ekc_scan/presentation/home_screen/models/product_model.dart';
import 'package:ekc_scan/presentation/home_screen/models/reason_model.dart';
import 'package:ekc_scan/presentation/home_screen/models/serial_ddl_model.dart';
import 'package:ekc_scan/presentation/home_screen/models/serialno_model.dart';
import 'package:ekc_scan/presentation/home_screen/repo/homepage_repo.dart';
import 'package:ekc_scan/service/http_service.dart';

import '../../../core/utils/storage_util.dart';
import '../../auth/controller/auth_controller.dart';

class HomePageController extends GetxController {
  static HomePageController get instance => Get.find<HomePageController>();
  Rx<bool> switchBool = Rx(false);
  RxInt lengthOfListOfOutlets = RxInt(0);
  RxInt lengthOfListOfCustomer = RxInt(0);

  var isLoading = false.obs;
  var isInitialized = false.obs;

  RxList<ProductModel> productList = RxList.empty();
  RxList<GasModel> gasList = RxList.empty();
  RxList<ReasonModel> reasonList = RxList.empty();
  RxList<PartyModel> partyList = RxList.empty();
  RxList<SerialNoModel> serialList = RxList.empty();

  static const String _getCommonPath = '/api_qrcode/index.php';

  void showOtherUserContextMenu() {
    showMenu(
      context: Get.context!,
      position: const RelativeRect.fromLTRB(10.0, 0.0, 0.0, 0.0),
      items: [
        const PopupMenuItem(
          value: 1,
          child: Text('Logout User'),
        ),
      ],
      elevation: 0.0,
    ).then((value) {
      // Handle the selected menu item here
      if (value != null) {
        switch (value) {
          case 1:
            showDialog(
              context: Get.context!,
              builder: (context) => SimpleDialog(
                backgroundColor: Colors.white,
                title: const Text("You want to logout?"),
                children: [
                  SimpleDialogOption(
                    child: const Text("Yes"),
                    onPressed: () {
                      AuthController.instance.logout();
                    },
                  ),
                  SimpleDialogOption(
                    child: const Text("No"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            );
            break;
        }
      }
    });
  }

  @override
  void onInit() async {
    if (!isInitialized.value) await getDdlData();

    isInitialized.value = true;

    super.onInit();
  }

  getDdlData() async {
    try {
      Map<String, dynamic> data = {
        "dbtype": "getPacklistDdl",
      };
      final result = await HttpService.post(_getCommonPath, data);

      SerialDdlModel serialDdlData;

      if (result['status'] == 200) {
        serialDdlData = SerialDdlModel.fromJson(result['data']);

        productList.addAll(serialDdlData.products);
        gasList.addAll(serialDdlData.gases);
        reasonList.addAll(serialDdlData.reasons);
        partyList.addAll(serialDdlData.customers);
        serialList.addAll(serialDdlData.serials);
      }
    } catch (e) {
      LogUtil.error(e);
      Get.snackbar('Error', "$e");
    }
  }
}
