import 'package:qr_code_scanner/presentation/auth/models/user_model.dart';
import 'package:qr_code_scanner/service/http_service_dynamic.dart';
import 'package:dio/dio.dart';

import '../../../core/utils/log_util.dart';
import '../../../core/utils/storage_util.dart';
import '../models/attendance_model.dart';

abstract class AttendanceRepo {
  static const String _uploadPicPath = '/api_image_upload/index.php';
  static const String _uploadAttendancePath = '/api_update/index.php';

  static Future<dynamic> uploadImage(
      imgString, String s, UserModel user, int attendId) async {
    try {
      Map<String, dynamic> data = {
        'locationId': user.locationId,
        'id': attendId,
        'filename': '${user.name!}${DateTime.now()}.png',
        'imagetype': s,
        'uploadedfile': 'data:image/png;base64,$imgString',
        'login': user.name
      };
      LogUtil.debug(data);
      var formData = FormData.fromMap(data);
      final result = await HttpServiceDynamic.picPost(_uploadPicPath, formData);
      if (result['success']) {
        return (result['imageurl']);
      } else {
        throw 'unauthorized';
      }
    } catch (e) {
      LogUtil.error(e);
      rethrow;
    }
  }

  static Future<int?> insertAttendance(AttendanceModel attendance) async {
    try {
      Map<String, dynamic> data = attendance.toJson();
      final result = await HttpServiceDynamic.post(_uploadAttendancePath, data);
      if (result['success']) {
        StorageUtil.writeAttendanceId(result['data']['attend_id'].toString());
        return (result['data']['attend_id']);
      } else {
        throw 'unauthorized';
      }
    } catch (e) {
      LogUtil.error(e);
      rethrow;
    }
  }

  static Future<void> updateAttendance(AttendanceModel attendance) async {
    try {
      Map<String, dynamic> data = attendance.toJson();
      final result = await HttpServiceDynamic.post(_uploadAttendancePath, data);
      if (result['success']) {
        LogUtil.debug(result['success']);
        return;
      } else {
        throw 'unauthorized';
      }
    } catch (e) {
      LogUtil.error(e);
      rethrow;
    }
  }
}
