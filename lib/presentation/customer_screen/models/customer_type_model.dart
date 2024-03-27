class CustomerTypeModel {
  int? id;
  String? value;

  CustomerTypeModel({this.id, this.value});

  factory CustomerTypeModel.fromJson(Map<String, dynamic> json) {
    int? commonId = json['common_id'];
    String? commonValue = json['common_value'];
    return CustomerTypeModel(id: commonId, value: commonValue);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['common_id'] = id;
    data['common_value'] = value;
    return data;
  }
}
