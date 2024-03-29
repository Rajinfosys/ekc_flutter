import '../../../core/utils/log_util.dart';
import '../../../core/utils/storage_util.dart';
import '../../../service/http_service_dynamic.dart';

abstract class HomePageRepo {
  static const String _dbTypeKey = 'dbtype';
  static const String _tokenUpdatePath = '/api_login/index.php';

  static Future<String> refreshToken(String token) async {
    try {
      Map<String, dynamic> data = {
        _dbTypeKey: "refreshToken",
        "refresh_token": token,
      };
      final result = await HttpServiceDynamic.post(_tokenUpdatePath, data);
      if (result['success']) {
        StorageUtil.deleteToken();
        StorageUtil.writeToken(result['data']['apitoken']);
        LogUtil.debug(result['data']['apitoken']);
        return result['data']['apitoken'];
      } else {
        throw 'unauthorized';
      }
    } catch (e) {
      LogUtil.error(e);
      rethrow;
    }
  }
}
