import 'package:ekc_scan/presentation/home_screen/models/serialno_model.dart';

class PacklistModel {
  String? packlistId;
  DateTime? transactionDate;
  String? transactionNo;
  String? valveMake;
  String? packing;
  String? valveWp;
  String? actualQty;
  String? partyId;
  List<SerialNoModel>? serialList;
  String? totalQuantity;
  String? productId;
  String? gasType;
  String? partyName;
  String? isClientSr;

  PacklistModel({
    this.packlistId,
    this.transactionDate,
    this.transactionNo,
    this.valveMake,
    this.packing,
    this.valveWp,
    this.actualQty,
    this.partyId,
    this.serialList,
    this.totalQuantity,
    this.productId,
    this.gasType,
    this.partyName,
    this.isClientSr,
  });

  factory PacklistModel.fromJson(Map<String, dynamic> json) {
    List<SerialNoModel> serialList = [];
    if (json['serialList'] != null) {
      json['serialList'].forEach((v) {
        serialList.add(SerialNoModel.fromJson(v));
      });
    }
    return PacklistModel(
      packlistId: (json['packlistid']).toString(),
      transactionDate: DateTime.parse(json['transaction_date']),
      transactionNo: json['transaction_no'],
      valveMake: json['valve_make'],
      packing: json['packing'],
      valveWp: json['valve_wp'],
      actualQty: json['actual_qty'].toString(),
      partyId: (json['partyid']).toString(),
      serialList: serialList,
      totalQuantity: (json['total_quantity']).toString(),
      productId: (json['productid']).toString(),
      gasType: json['gas_type'],
      partyName: json['party_name'],
      isClientSr: json['is_client_sr'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['packlistid'] = packlistId;
    data['transaction_date'] = transactionDate;
    data['transaction_no'] = transactionNo;
    data['valve_make'] = valveMake;
    data['packing'] = packing;
    data['valve_wp'] = valveWp;
    data['actual_qty'] = actualQty;
    data['partyid'] = partyId;
    data['serialList'] = serialList!.map((v) => v.toJson()).toList();
    data['total_quantity'] = totalQuantity;
    data['productid'] = productId;
    data['gas_type'] = gasType;
    data['party_name'] = partyName;
    data['is_client_sr'] = isClientSr;
    return data;
  }
}
