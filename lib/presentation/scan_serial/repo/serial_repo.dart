import 'package:qr_code_scanner/presentation/scan_serial/models/serial_ddl_model.dart';
import 'package:qr_code_scanner/service/http_service_dynamic.dart';
import 'package:qr_code_scanner/service/http_service.dart';

import '../../../core/utils/log_util.dart';

abstract class SerialRepo {
  static const String _getCommonPath = '/api_qrcode/index.php';
  static const String _dbTypeKey = 'dbtype';
  static const String _dbDdlTypeValue = 'getDdl';

  // static Future<void> updateOutlet(OutletModel shop) async {
  //   try {
  //     Map<String, dynamic> data = {
  //       _dbTypeKey: "updateOutlet",
  //       "company_id": shop.locationId,
  //       "outlet_id": shop.outletId,
  //       "outlet_name": shop.outletName,
  //       "owner_name": shop.ownerName,
  //       "owner_email": shop.ownerEmail,
  //       "owner_number": shop.ownerNumber,
  //       "owner_age": shop.ownerAge,
  //       "address": shop.address,
  //       "cityname": shop.cityName,
  //       "areaname": shop.areaName,
  //       "pincode": shop.pinCode
  //     };
  //     final result = await HttpServiceDynamic.post(_commonOutletPath, data);
  //     if (result['success']) {
  //       // LogUtil.warning(result['message']);
  //     } else {
  //       throw 'unauthorized';
  //     }
  //   } catch (e) {
  //     LogUtil.error(e);
  //     rethrow;
  //   }
  // }

  static Future<SerialDdlModel> getDdlData() async {
    SerialDdlModel serialDdlData;

    try {
      Map<String, dynamic> data = {
        _dbTypeKey: _dbDdlTypeValue,
      };
      final result = await HttpService.post(_getCommonPath, data);
      if (result['success']) {
        serialDdlData = SerialDdlModel.fromJson(result['data']);
      } else {
        throw 'unauthorized';
      }
    } catch (e) {
      LogUtil.error(e);
      rethrow;
    }
    return serialDdlData;
  }
}
