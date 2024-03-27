class AreaModel {
  int? id;
  String? areaName;
  String? cityName;
  String? pinCode;

  AreaModel({this.id, this.areaName, this.cityName, this.pinCode});

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    int? areaId = json['area_id'];
    String? area = json['area_name'];
    String? city = json['city_name'];
    String? pin = json['pincode'];

    return AreaModel(id: areaId, areaName: area, cityName: city, pinCode: pin);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['area_id'] = id;
    data['area_name'] = areaName;
    data['city_name'] = cityName;
    data['pincode'] = pinCode;
    return data;
  }
}
