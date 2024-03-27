import 'package:qr_code_scanner/presentation/attendance/models/attendance_model.dart';
import 'package:qr_code_scanner/presentation/outlet_screen/models/shop_model.dart';

import '../../../core/utils/log_util.dart';
import '../../../core/utils/storage_util.dart';
import '../../../service/http_service_dynamic.dart';

import '../../auth/controller/auth_controller.dart';
import '../../customer_screen/models/customer_model.dart';

abstract class HomePageRepo {
  static const String _outletsListTypeValue = 'getOutlets';
  static const String _dbTypeKey = 'dbtype';
  static const String _locationIdKey = 'company_id';
  static const String _attendIdKey = 'attend_id';
  static const String _customerPath = '/api_select/index.php';
  static const String _tokenUpdatePath = '/api_login/index.php';
  static const String _customerListTypeValue = 'getCustomers';
  static const String _getAttendanceKey = 'getAttendanceById';

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

  static Future<AttendanceModel> getAttendance(int attendId) async {
    try {
      Map<String, dynamic> data = {
        _dbTypeKey: _getAttendanceKey,
        _attendIdKey: attendId
      };
      final result = await HttpServiceDynamic.post(
        _customerPath,
        data,
      );
      if (result['success']) {
        return AttendanceModel.fromJson(result['data']);
      } else {
        throw 'unauthorized';
      }
    } catch (e) {
      LogUtil.error(e);
      rethrow;
    }
  }

  static Future<List<OutletModel>> getListOfOutlets() async {
    List<OutletModel> resultList = [];
    try {
      Map<String, dynamic> data = {
        _dbTypeKey: _outletsListTypeValue,
        _locationIdKey: AuthController.instance.user!.locationId
      };
      final result = await HttpServiceDynamic.post(
        _customerPath,
        data,
      );
      if (result['success']) {
        List<dynamic> customersData = result['data'];
        for (var element in customersData) {
          resultList.add(OutletModel.fromJson(element));
        }
        return resultList;
      } else {
        throw 'unauthorized';
      }
    } catch (e) {
      LogUtil.error(e);
      rethrow;
    }
  }

  static Future<List<CustomerModel>> getListOfCustomers() async {
    List<CustomerModel> resultList = [];
    try {
      Map<String, dynamic> data = {
        _dbTypeKey: _customerListTypeValue,
        _locationIdKey: AuthController.instance.user!.locationId
      };
      final result = await HttpServiceDynamic.post(
        _customerPath,
        data,
      );
      if (result['status'] == 200) {
        List<dynamic> customersData = result['data'];
        for (var element in customersData) {
          resultList.add(CustomerModel.fromJson(element));
        }
        return resultList;
      } else {
        throw 'unauthorized';
      }
    } catch (e) {
      LogUtil.error(e);
      rethrow;
    }
  }
}
