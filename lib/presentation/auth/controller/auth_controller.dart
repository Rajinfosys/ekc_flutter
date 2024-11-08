import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:ekc_scan/core/utils/log_util.dart';
import 'package:ekc_scan/presentation/auth/auth_screen.dart';
import 'package:ekc_scan/presentation/auth/models/user_model.dart';
import 'package:ekc_scan/presentation/home_screen/home_page.dart';
import 'package:get/get.dart';
import 'package:ekc_scan/service/http_service.dart';

import '../../../core/utils/storage_util.dart';
import '../../../service/http_service_dynamic.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find<AuthController>();
  RxBool isLoading = RxBool(false);
  var authToken = ''.obs;
  RxBool isObscure = RxBool(false);
  UserModel? user;

  static const String _loginPath = '/scriptcase/app/ekc_qc/api_login/index.php';

  Rx<TextEditingController> apiBase = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();

    checkLogin();
  }

  checkLogin() async {
    isLoading(true);
    await Future.delayed(const Duration(seconds: 2));
    if (StorageUtil.getToken() != null) {
      user = UserModel.fromJson(jsonDecode(StorageUtil.getUserData()!));
      HttpServiceDynamic.initialize(user!.baseUrl!);
      Get.offNamed(HomePage.routeName);
      isLoading(false);
    } else {
      Get.offNamed(LoginView.routeName);
      isLoading(false);
    }
  }

  void login({required String email, required String password}) async {
    isLoading(true);
    try {
      Map<String, dynamic> data = {
        "login": email,
        "password": password,
        'dbtype': 'isValidUser'
      };

      var user;
      // LogUtil.debug(StorageUtil.);

      final result = await HttpService.post(_loginPath, data);
      if (result['success']) {
        StorageUtil.writeUserData(jsonEncode(result['data']));
        StorageUtil.writeToken(result['data']['apitoken']);
        LogUtil.debug(result['data']);
        user = UserModel.fromJson(result['data']);
      } else if (result['status'] == 404) {
        throw 'Check username or password';
      }
      LogUtil.debug(user?.toJson());
      if (user != null) {
        HttpServiceDynamic.initialize(user!.baseUrl!);
        update();
        Get.offNamed(HomePage.routeName);
      }
      isLoading(false);
    } catch (e) {
      isLoading(false);
      Get.snackbar('Error', "$e");

      ///Error occurred
    }
  }

  void logout({String? email, String? password}) async {
    isLoading(true);
    try {
      StorageUtil.deleteToken();
      StorageUtil.deleteUserData();
      user = null;
      Get.offAll(() => LoginView());
    } catch (e) {
      isLoading(false);
      Get.snackbar('Error', "$e");

      ///Error occurred
    }
    isLoading(false);
  }

  void toggle() {
    isObscure.value = !isObscure.value;
  }
}
