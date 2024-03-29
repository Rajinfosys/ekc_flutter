class QcModel {
  int? qcid;
  int? batchid;
  List<QcRowModel>? qc_rows;

  QcModel({this.qcid, this.batchid, this.qc_rows});

  factory QcModel.fromJson(Map<String, dynamic> json) {
    int? qcid = json['qcid'];
    int? batchid = json['batchid'];
    List<QcRowModel> qc_rows = List<QcRowModel>.from(
        json['qc_rows'].map((x) => QcRowModel.fromJson(x)));
    return QcModel(qcid: qcid, batchid: batchid, qc_rows: qc_rows);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['qcid'] = qcid;
    data['batchid'] = batchid;
    data['qc_rows'] = List<dynamic>.from(qc_rows!.map((x) => x.toJson()));
    return data;
  }
}

class QcRowModel {
  int? qcdtlid;
  int? seqno;
  String? qc_name;
  String? qc_ok;
  String? qc_reason;
  String? serialno;

  QcRowModel(
      {this.qcdtlid,
      this.seqno,
      this.qc_name,
      this.qc_ok,
      this.qc_reason,
      this.serialno});

  factory QcRowModel.fromJson(Map<String, dynamic> json) {
    int? qcdtlid = json['qcdtlid'];
    int? seqno = json['seqno'];
    String? qc_name = json['qc_name'];
    String? qc_ok = json['qc_ok'];
    String? qc_reason = json['qc_reason'];
    String? serialno = json['serialno'];
    return QcRowModel(
        qcdtlid: qcdtlid,
        seqno: seqno,
        qc_name: qc_name,
        qc_ok: qc_ok,
        qc_reason: qc_reason,
        serialno: serialno);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['qcdtlid'] = qcdtlid;
    data['seqno'] = seqno;
    data['qc_name'] = qc_name;
    data['qc_ok'] = qc_ok;
    data['qc_reason'] = qc_reason;
    data['serialno'] = serialno;
    return data;
  }
}
