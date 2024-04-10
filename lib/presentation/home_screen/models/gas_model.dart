class GasModel {
  String? gasId;
  String? gasName;

  GasModel({this.gasId, this.gasName});

  factory GasModel.fromJson(Map<String, dynamic> json) {
    String? gasId = (json['commonid']).toString();
    String? gasName = json['common_label'];
    return GasModel(gasId: gasId, gasName: gasName);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['commonid'] = gasId;
    data['common_label'] = gasName;
    return data;
  }
}
