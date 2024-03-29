class SerialModel {
  int? productId;
  String? gas;
  String? code;
  int? isTesting;

  SerialModel({this.productId, this.gas, this.code, this.isTesting});

  factory SerialModel.fromJson(Map<String, dynamic> json) {
    int? productId = json['product_id'];
    String? gas = json['gas'];
    String? code = json['code'];
    int? isTesting = json['is_testing'];
    return SerialModel(
        productId: productId, gas: gas, code: code, isTesting: isTesting);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['product_id'] = productId;
    data['gas'] = gas;
    data['code'] = code;
    data['is_testing'] = isTesting;
    return data;
  }
}
