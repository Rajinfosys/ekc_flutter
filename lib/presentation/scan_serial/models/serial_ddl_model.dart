import 'package:qr_code_scanner/presentation/branding_sales/models/product_model.dart';
import 'package:qr_code_scanner/presentation/scan_serial/models/gas_model.dart';
import 'package:qr_code_scanner/presentation/scan_serial/models/reason_model.dart';

class SerialDdlModel {
  // consists of arrays of products , gases and reansons
  List<ProductModel> products;
  List<GasModel> gases;
  List<ReasonModel> reasons;

  SerialDdlModel({
    required this.products,
    required this.gases,
    required this.reasons,
  });

  factory SerialDdlModel.fromJson(Map<String, dynamic> json) {
    return SerialDdlModel(
      products: List<ProductModel>.from(
          json["products"].map((x) => ProductModel.fromJson(x))),
      gases:
          List<GasModel>.from(json["gases"].map((x) => GasModel.fromJson(x))),
      reasons: List<ReasonModel>.from(
          json["reasons"].map((x) => ReasonModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data["products"] = List<dynamic>.from(products.map((x) => x.toJson()));
    data["gases"] = List<dynamic>.from(gases.map((x) => x.toJson()));
    data["reasons"] = List<dynamic>.from(reasons.map((x) => x.toJson()));
    return data;
  }
}
