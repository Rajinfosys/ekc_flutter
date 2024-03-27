import 'package:qr_code_scanner/presentation/customer_screen/models/customer_model.dart';
import 'package:qr_code_scanner/presentation/customer_screen/models/customer_type_model.dart';
import 'package:qr_code_scanner/service/http_service_dynamic.dart';
import 'package:get/get.dart';

import '../../../core/utils/app_color.dart';
import '../../../core/utils/log_util.dart';

abstract class CustomerRepo {
  static const String _getCommonPath = '/api_select/index.php';
  static const String _dbTypeKey = 'dbtype';
  static const String _commonDbTypeValue = 'getCommons';
  static const String _customerByOutletDbTypeValue = 'getCustomerByOutlet';

  static const String _commonTypeKey = 'common_type';
  static const String _customerTypeValue = 'customer_type';
  static const String _salesTypeValue = 'sale_type';
  static const String _brandingTypeValue = 'branding_type';
  static const String _outletIdKey = 'outlet_id';
  static const String _customerPath = '/api_select/index.php';
  static const String _commonCustomerPath = '/api_update/index.php';

  static Future<void> updateCustomer(CustomerModel customer) async {
    try {
      Map<String, dynamic> data = customer.toJson();
      final result = await HttpServiceDynamic.post(_commonCustomerPath, data);
      if (result['success']) {
        LogUtil.warning(result['message']);
      } else {
        throw 'unauthorized';
      }
    } catch (e) {
      LogUtil.error(e);
      rethrow;
    }
  }

  static Future<void> deleteCustomer(CustomerModel customer) async {
    try {
      Map<String, dynamic> data = {
        _dbTypeKey: "deleteCustomer",
        "customer_id": customer.customerId
      };
      final result = await HttpServiceDynamic.post(_commonCustomerPath, data);
      if (result['success']) {
        Get.snackbar(
          'Warning',
          'customer has been deleted',
          colorText: AppColors.white,
          backgroundColor: AppColors.green,
        );
        LogUtil.debug('customer has been deleted');
        return;
      } else {
        throw 'unauthorized';
      }
    } catch (e) {
      LogUtil.error(e);
      rethrow;
    }
  }

  static Future<int> insertCustomer(CustomerModel customer) async {
    try {
      Map<String, dynamic> data = customer.toJson();
      final result = await HttpServiceDynamic.post(_commonCustomerPath, data);
      if (result['success']) {
        return (result['data']['customer_id']);
      } else {
        throw 'unauthorized';
      }
    } catch (e) {
      LogUtil.error(e);
      rethrow;
    }
  }

  static Future<List<CustomerModel>> getCustomers(int outletId) async {
    List<CustomerModel> resultList = [];
    try {
      Map<String, dynamic> data = {
        _dbTypeKey: _customerByOutletDbTypeValue,
        _outletIdKey: outletId
      };
      final result = await HttpServiceDynamic.post(
        _customerPath,
        data,
      );
      if (result['success']) {
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

  static Future<List<CustomerTypeModel>> getCustomerType() async {
    List<CustomerTypeModel> resultList = [];
    try {
      Map<String, dynamic> data = {
        _dbTypeKey: _commonDbTypeValue,
        _commonTypeKey: _customerTypeValue
      };
      final result = await HttpServiceDynamic.post(_getCommonPath, data);
      if (result['success']) {
        List<dynamic> customerTypesData = result['data'];
        for (var element in customerTypesData) {
          resultList.add(CustomerTypeModel.fromJson(element));
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

  static Future<List<CustomerTypeModel>> getSalesType() async {
    List<CustomerTypeModel> resultList = [];
    try {
      Map<String, dynamic> data = {
        _dbTypeKey: _commonDbTypeValue,
        _commonTypeKey: _salesTypeValue
      };
      final result = await HttpServiceDynamic.post(_getCommonPath, data);
      // LogUtil.warning(result);
      if (result['success']) {
        List<dynamic> customerTypesData = result['data'];
        for (var element in customerTypesData) {
          resultList.add(CustomerTypeModel.fromJson(element));
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

  static Future<List<CustomerTypeModel>> getBrandingType() async {
    List<CustomerTypeModel> resultList = [];
    try {
      Map<String, dynamic> data = {
        _dbTypeKey: _commonDbTypeValue,
        _commonTypeKey: _brandingTypeValue,
      };
      final result = await HttpServiceDynamic.post(_getCommonPath, data);
      // LogUtil.warning(result);
      if (result['success']) {
        List<dynamic> customerTypesData = result['data'];
        for (var element in customerTypesData) {
          resultList.add(CustomerTypeModel.fromJson(element));
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
}
