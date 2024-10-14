class SerialNoModel {
  String? packlistdtlid;
  String? serialno;
  String? gas_type;
  String? batchid;
  String? productid;
  String? tar_weight;
  String? client_serialno;

  SerialNoModel(
      {this.packlistdtlid,
      this.serialno,
      this.gas_type,
      this.batchid,
      this.productid,
      this.tar_weight,
      this.client_serialno});

  factory SerialNoModel.fromJson(Map<String, dynamic> json) {
    String? packlistdtlid = (json['packlistdtlid']).toString();
    String? serialno = json['serialno'];
    String? gas_type = json['gas_type'];
    String? batchid = (json['batchid']).toString();
    String? productid = (json['productid']).toString();
    String? tar_weight = (json['tar_weight']).toString();
    String? client_serialno = json['client_serialno'];

    return SerialNoModel(
        packlistdtlid: packlistdtlid,
        serialno: serialno,
        gas_type: gas_type,
        batchid: batchid,
        productid: productid,
        tar_weight: tar_weight,
        client_serialno: client_serialno);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['packlistdtlid'] = packlistdtlid;
    data['serialno'] = serialno;
    data['gas_type'] = gas_type;
    data['batchid'] = batchid;
    data['productid'] = productid;
    data['tar_weight'] = tar_weight;
    data['client_serialno'] = client_serialno;
    return data;
  }
}
