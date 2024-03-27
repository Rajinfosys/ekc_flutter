class CityModel {
  int? id;
  String? name;

  CityModel({this.id, this.name});

  factory CityModel.fromJson(Map<String, dynamic> json) {
    int? cityId = json['city_id'];
    String? cityName = json['city_name'];
    return CityModel(id: cityId, name: cityName);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['city_id'] = id;
    data['city_name'] = name;
    return data;
  }
}
