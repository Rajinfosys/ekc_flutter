import 'package:qr_code_scanner/core/utils/app_color.dart';
import 'package:qr_code_scanner/service/http_service_dynamic.dart';
import 'package:get/get.dart';

import '../../../core/utils/log_util.dart';
import '../../auth/controller/auth_controller.dart';
import '../models/areas_model.dart';
import '../models/city_model.dart';
import '../models/shop_model.dart';

abstract class ShopRepo {
  static const String _getCommonPath = '/api_select/index.php';
  static const String _dbTypeKey = 'dbtype';
  static const String _dbCityTypeValue = 'getCities';
  static const String _dbAreasTypeValue = 'getAreas';

  static const String _outletPath = '/api_select/index.php';
  static const String _commonOutletPath = '/api_update/index.php';

  static Future<int> insertOutlet(OutletModel shop) async {
    try {
      Map<String, dynamic> data = {
        _dbTypeKey: "insertOutlet",
        "company_id": AuthController.instance.user!.locationId,
        "outlet_name": shop.outletName,
        "owner_name": shop.ownerName,
        "owner_email": shop.ownerEmail,
        "owner_number": shop.ownerNumber,
        "owner_age": shop.ownerAge,
        "address": shop.address,
        "cityname": shop.cityName,
        "areaname": shop.areaName,
        "pincode": shop.pinCode
      };
      final result = await HttpServiceDynamic.post(_commonOutletPath, data);
      if (result['success']) {
        LogUtil.debug(result['data']['outlet_id']);
        return (result['data']['outlet_id']);
      } else {
        throw 'unauthorized';
      }
    } catch (e) {
      LogUtil.error(e);
      rethrow;
    }
  }

  static Future<void> deleteOutlet(OutletModel outlet) async {
    try {
      Map<String, dynamic> data = {
        _dbTypeKey: "deleteOutlet",
        "outlet_id": outlet.outletId
      };
      final result = await HttpServiceDynamic.post(_commonOutletPath, data);
      if (result['success']) {
        Get.snackbar(
          'Warning',
          'outlet has been deleted',
          colorText: AppColors.white,
          backgroundColor: AppColors.green,
        );
        LogUtil.debug('outlet has been deleted');
        return;
      } else {
        throw 'unauthorized';
      }
    } catch (e) {
      LogUtil.error(e);
      rethrow;
    }
  }

  static Future<List<OutletModel>> getOutlets() async {
    List<OutletModel> resultList = [];
    try {
      Map<String, dynamic> data = {
        'company_id': AuthController.instance.user!.locationId,
        _dbTypeKey: 'getOutlets'
      };
      final result = await HttpServiceDynamic.post(_outletPath, data);
      if (result['success']) {
        List<dynamic> outletData = result['data'];
        for (var element in outletData) {
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

  static Future<List<CityModel>> getCitesData() async {
    List<CityModel> resultList = [];
    try {
      Map<String, dynamic> data = {
        _dbTypeKey: _dbCityTypeValue,
      };
      final result = await HttpServiceDynamic.post(_getCommonPath, data);
      if (result['success']) {
        List<dynamic> citiesData = result['data'];
        for (var element in citiesData) {
          resultList.add(CityModel.fromJson(element));
        }
      } else {
        throw 'unauthorized';
      }
    } catch (e) {
      LogUtil.error(e);
      rethrow;
    }
    return resultList;
  }

  static Future<List<AreaModel>> getAreasData() async {
    List<AreaModel> resultList = [];
    try {
      Map<String, dynamic> data = {
        _dbTypeKey: _dbAreasTypeValue,
      };
      final result = await HttpServiceDynamic.post(_getCommonPath, data);
      // LogUtil.warning(result);
      if (result['success']) {
        List<dynamic> areasData = result['data'];
        for (var element in areasData) {
          resultList.add(AreaModel.fromJson(element));
        }
      } else {
        throw 'unauthorized';
      }
    } catch (e) {
      LogUtil.error(e);
      rethrow;
    }
    return resultList;
  }

  static Future<void> updateOutlet(OutletModel shop) async {
    try {
      Map<String, dynamic> data = {
        _dbTypeKey: "updateOutlet",
        "company_id": shop.locationId,
        "outlet_id": shop.outletId,
        "outlet_name": shop.outletName,
        "owner_name": shop.ownerName,
        "owner_email": shop.ownerEmail,
        "owner_number": shop.ownerNumber,
        "owner_age": shop.ownerAge,
        "address": shop.address,
        "cityname": shop.cityName,
        "areaname": shop.areaName,
        "pincode": shop.pinCode
      };
      final result = await HttpServiceDynamic.post(_commonOutletPath, data);
      if (result['success']) {
        // LogUtil.warning(result['message']);
      } else {
        throw 'unauthorized';
      }
    } catch (e) {
      LogUtil.error(e);
      rethrow;
    }
  }
}
