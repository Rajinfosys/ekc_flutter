import 'dart:convert';

import 'package:qr_code_scanner/core/utils/log_util.dart';
import 'package:qr_code_scanner/presentation/auth/auth_screen.dart';
import 'package:qr_code_scanner/presentation/auth/models/user_model.dart';
import 'package:qr_code_scanner/presentation/auth/repo/auth_repo.dart';
import 'package:qr_code_scanner/presentation/home_screen/home_page.dart';
import 'package:get/get.dart';

import '../../../core/utils/storage_util.dart';
import '../../../service/http_service_dynamic.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find<AuthController>();
  RxBool isLoading = RxBool(false);
  var authToken = ''.obs;
  RxBool isObscure = RxBool(false);
  UserModel? user;

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
      user = await AuthRepo.login(email, password);
      LogUtil.debug(user!.toJson());
      if (user != null) {
        HttpServiceDynamic.initialize(user!.baseUrl!);
        update();
        isLoading(false);
        Get.offNamed(HomePage.routeName);
      }
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
