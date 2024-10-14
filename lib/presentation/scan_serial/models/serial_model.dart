class SerialModel {
  String? productId;
  String? gas;
  String? code;
  String? isTesting;
  String? isClientSr;

  SerialModel(
      {this.productId, this.gas, this.code, this.isTesting, this.isClientSr});

  factory SerialModel.fromJson(Map<String, dynamic> json) {
    String? productId = (json['product_id']).toString();
    String? gas = json['gas'];
    String? code = json['code'];
    String? isTesting = (json['is_testing']).toString();
    String? isClientSr = (json['is_client_sr']).toString();
    return SerialModel(
        productId: productId,
        gas: gas,
        code: code,
        isTesting: isTesting,
        isClientSr: isClientSr);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['product_id'] = productId;
    data['gas'] = gas;
    data['code'] = code;
    data['is_testing'] = isTesting;
    data['is_client_sr'] = isClientSr;
    return data;
  }
}
