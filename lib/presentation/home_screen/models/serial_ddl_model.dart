import 'package:qr_code_scanner/presentation/home_screen/models/customer_model.dart';
import 'package:qr_code_scanner/presentation/home_screen/models/gas_model.dart';
import 'package:qr_code_scanner/presentation/home_screen/models/product_model.dart';
import 'package:qr_code_scanner/presentation/home_screen/models/reason_model.dart';
import 'package:qr_code_scanner/presentation/home_screen/models/serialno_model.dart';

class SerialDdlModel {
  // consists of arrays of products , gases and reasons
  List<ProductModel> products;
  List<GasModel> gases;
  List<ReasonModel> reasons;
  List<PartyModel> customers;
  List<SerialNoModel> serials;

  SerialDdlModel({
    required this.products,
    required this.gases,
    required this.reasons,
    required this.customers,
    required this.serials,
  });

  factory SerialDdlModel.fromJson(Map<String, dynamic> json) {
    return SerialDdlModel(
      products: List<ProductModel>.from(
          json["products"].map((x) => ProductModel.fromJson(x))),
      gases:
          List<GasModel>.from(json["gases"].map((x) => GasModel.fromJson(x))),
      reasons: List<ReasonModel>.from(
          json["reasons"].map((x) => ReasonModel.fromJson(x))),
      customers: List<PartyModel>.from(
          json["customers"].map((x) => PartyModel.fromJson(x))),
      serials: List<SerialNoModel>.from(
          json["serials"].map((x) => SerialNoModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data["products"] = List<dynamic>.from(products.map((x) => x.toJson()));
    data["gases"] = List<dynamic>.from(gases.map((x) => x.toJson()));
    data["reasons"] = List<dynamic>.from(reasons.map((x) => x.toJson()));
    data["customers"] = List<dynamic>.from(customers.map((x) => x.toJson()));
    data["serials"] = List<dynamic>.from(serials.map((x) => x.toJson()));
    return data;
  }
}
