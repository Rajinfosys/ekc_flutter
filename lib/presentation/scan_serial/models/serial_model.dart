class SerialModel {
  String? productId;
  String? gas;
  String? code;
  String? isTesting;

  SerialModel({this.productId, this.gas, this.code, this.isTesting});

  factory SerialModel.fromJson(Map<String, dynamic> json) {
    String? productId = (json['product_id']).toString();
    String? gas = json['gas'];
    String? code = json['code'];
    String? isTesting = (json['is_testing']).toString();
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
