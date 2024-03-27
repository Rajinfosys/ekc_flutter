class ReasonModel {
  int? reasonId;
  String? reasonName;

  ReasonModel({this.reasonId, this.reasonName});

  factory ReasonModel.fromJson(Map<String, dynamic> json) {
    int? reasonId = json['commonid'];
    String? reasonName = json['common_label'];
    return ReasonModel(reasonId: reasonId, reasonName: reasonName);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['commonid'] = reasonId;
    data['common_label'] = reasonName;
    return data;
  }
}