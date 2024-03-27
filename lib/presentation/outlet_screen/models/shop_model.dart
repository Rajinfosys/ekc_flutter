class OutletModel {
  int? locationId;
  int? outletId;
  String? outletName;
  String? ownerName;
  String? ownerEmail;
  String? ownerNumber;
  int? ownerAge;
  String? address;
  String? cityName;
  String? areaName;
  String? pinCode;

  OutletModel(
      {this.locationId,
      this.outletId,
      this.outletName,
      this.ownerName,
      this.ownerEmail,
      this.ownerNumber,
      this.ownerAge,
      this.address,
      this.cityName,
      this.areaName,
      this.pinCode});

  factory OutletModel.fromJson(Map<String, dynamic> json) {
    int? locationId = json['company_id'];
    int? outletId = json['outlet_id'];
    String? outletName = json['outlet_name'];
    String? ownerName = json['owner_name'];
    String? ownerEmail = json['owner_email'];
    String? ownerNumber = json['owner_number'];
    int? ownerAge = json['owner_age'];
    String? address = json['address'];
    String? cityName = json['cityname'];
    String? areaName = json['areaname'];
    String? pinCode = json['pincode'];

    return OutletModel(
        locationId: locationId,
        outletId: outletId,
        outletName: outletName,
        ownerName: ownerName,
        ownerEmail: ownerEmail,
        ownerNumber: ownerNumber,
        ownerAge: ownerAge,
        address: address,
        cityName: cityName,
        areaName: areaName,
        pinCode: pinCode);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['company_id'] = locationId;
    data['outlet_id'] = outletId;
    data['outlet_name'] = outletName;
    data['owner_name'] = ownerName;
    data['owner_email'] = ownerEmail;
    data['owner_number'] = ownerNumber;
    data['owner_age'] = (ownerAge!);
    data['address'] = address;
    data['cityname'] = cityName;
    data['areaname'] = areaName;
    data['pincode'] = pinCode;
    return data;
  }
}
