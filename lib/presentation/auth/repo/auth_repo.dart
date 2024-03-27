import 'dart:convert';

import 'package:qr_code_scanner/presentation/auth/models/user_model.dart';
import 'package:qr_code_scanner/service/http_service.dart';

import '../../../core/utils/log_util.dart';
import '../../../core/utils/storage_util.dart';

abstract class AuthRepo {
  static const String _loginPath = '/api_login/index.php';
  static const String _usernameKey = 'login';
  static const String _passwordKey = 'password';

  static Future<UserModel?> login(String email, String password) async {
    try {
      Map<String, dynamic> data = {
        _usernameKey: email,
        _passwordKey: password,
        'dbtype': 'isValidUser'
      };
      final result = await HttpService.post(_loginPath, data);
      if (result['success']) {
        StorageUtil.writeUserData(jsonEncode(result['data']));
        StorageUtil.writeToken(result['data']['apitoken']);
        return UserModel.fromJson(result['data']);
      } else if (result['status'] == 404) {
        throw 'Check username or password';
      } else {
        throw 'unauthorized';
      }
    } catch (e) {
      LogUtil.error(e);
      rethrow;
    }
  }
}
