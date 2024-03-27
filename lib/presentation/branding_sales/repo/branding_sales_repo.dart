import '../../../core/utils/log_util.dart';
import '../../../service/http_service_dynamic.dart';
import '../models/branding_model.dart';
import '../models/product_model.dart';

abstract class BrandingSalesRepo {
  static const String _brandingSalesPath = '/api_update/index.php';
  static const String _brandingPath = '/api_select/index.php';
  static const String _dbTypeKey = 'dbtype';
  static const String _customerIdKey = 'customer_id';
  static const String _outletIdKey = 'outlet_id';
  static const String _brandingByCustomerId = 'getBrandingByCustomer';
  static const String _brandingByOutletId = 'getBrandingByOutlet';
  static const String _productsByCustomerId = 'getCustOrdersByCustomer';

  static Future<void> updateProduct(ProductModel product) async {
    try {
      Map<String, dynamic> data = product.toJson();
      final result = await HttpServiceDynamic.post(_brandingSalesPath, data);
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

  static Future<void> updateBranding(Map<String, dynamic> data) async {
    try {
      final result = await HttpServiceDynamic.post(_brandingSalesPath, data);
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

  static Future<List<BrandingModel>> getBrandingByOutlet(int outletId) async {
    List<BrandingModel> resultList = [];
    try {
      Map<String, dynamic> data = {
        _dbTypeKey: _brandingByOutletId,
        _outletIdKey: outletId
      };
      final result = await HttpServiceDynamic.post(
        _brandingPath,
        data,
      );
      if (result['success']) {
        List<dynamic> brandingData = result['data'];

        for (var element in brandingData) {
          resultList.add(BrandingModel.fromJsonOutlet(element));
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

  static Future<List<BrandingModel>> getBranding(int customerId) async {
    List<BrandingModel> resultList = [];
    try {
      Map<String, dynamic> data = {
        _dbTypeKey: _brandingByCustomerId,
        _customerIdKey: customerId
      };
      final result = await HttpServiceDynamic.post(
        _brandingPath,
        data,
      );
      if (result['success']) {
        List<dynamic> brandingData = result['data'];

        for (var element in brandingData) {
          resultList.add(BrandingModel.fromJsonCustomer(element));
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

  static Future<List<ProductModel>> getProducts(int customerId) async {
    List<ProductModel> resultList = [];
    try {
      Map<String, dynamic> data = {
        _dbTypeKey: _productsByCustomerId,
        _customerIdKey: customerId
      };
      final result = await HttpServiceDynamic.post(
        _brandingPath,
        data,
      );
      if (result['success']) {
        List<dynamic> productsData = result['data'];
        for (var element in productsData) {
          resultList.add(ProductModel.fromJson(element));
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

  static Future<int> insertOutletBranding(BrandingModel brand) async {
    try {
      Map<String, dynamic> data = brand.toJsonOutlet();
      final result = await HttpServiceDynamic.post(_brandingSalesPath, data);
      if (result['success']) {
        LogUtil.debug(result['data']['branding_id']);
        return (result['data']['branding_id']);
      } else {
        throw 'unauthorized';
      }
    } catch (e) {
      LogUtil.error(e);
      rethrow;
    }
  }

  static Future<int> insertProduct(ProductModel product) async {
    try {
      Map<String, dynamic> data = product.toJson();
      final result = await HttpServiceDynamic.post(_brandingSalesPath, data);
      if (result['success']) {
        LogUtil.debug(result['data']['order_id']);
        return (result['data']['order_id']);
      } else {
        throw 'unauthorized';
      }
    } catch (e) {
      LogUtil.error(e);
      rethrow;
    }
  }

  static Future<int> insertCustomerBranding(BrandingModel brand) async {
    try {
      Map<String, dynamic> data = brand.toJsonCustomer();
      final result = await HttpServiceDynamic.post(_brandingSalesPath, data);
      if (result['success']) {
        return (result['data']['branding_id']);
      } else {
        throw 'unauthorized';
      }
    } catch (e) {
      LogUtil.error(e);
      rethrow;
    }
  }
}
