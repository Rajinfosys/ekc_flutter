class SerialNoModel {
  String? serialno;
  String? gas_type;
  int? batchid;
  int? productid;
  String? tar_weight;

  SerialNoModel(
      {this.serialno,
      this.gas_type,
      this.batchid,
      this.productid,
      this.tar_weight});

  factory SerialNoModel.fromJson(Map<String, dynamic> json) {
    String? serialno = json['serialno'];
    String? gas_type = json['gas_type'];
    int? batchid = json['batchid'];
    int? productid = json['productid'];
    String? tar_weight = json['tar_weight'];
    return SerialNoModel(
        serialno: serialno,
        gas_type: gas_type,
        batchid: batchid,
        productid: productid,
        tar_weight: tar_weight);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['serialno'] = serialno;
    data['gas_type'] = gas_type;
    data['batchid'] = batchid;
    data['productid'] = productid;
    data['tar_weight'] = tar_weight;
    return data;
  }
}
