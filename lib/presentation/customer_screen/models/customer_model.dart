class CustomerModel {
  String? dbType;
  int? customerId;
  int? locationId;
  int? outletId;
  String? customerType;
  String? customerName;
  String? customerNumber;
  int? customerAge;
  String? customerEmail;
  String? maritalStatus;
  int? noOfKids;
  String? address;
  String? cityName;
  String? areaName;
  String? pinCode;
  int? isEnquired;
  String? enquiryType;
  int? brandingDone;
  String? brandingType;
  int? salesDone;
  String? siteAddress;
  String? siteCity;
  String? giftGiven;
  String? brandingPicPath;
  String? customerPicPath;

  CustomerModel(
      {this.dbType,
      this.customerId,
      this.locationId,
      this.outletId,
      this.customerType,
      this.customerName,
      this.customerNumber,
      this.customerAge,
      this.customerEmail,
      this.maritalStatus,
      this.noOfKids,
      this.address,
      this.cityName,
      this.areaName,
      this.pinCode,
      this.isEnquired,
      this.enquiryType,
      this.brandingDone,
      this.brandingType,
      this.salesDone,
      this.siteAddress,
      this.siteCity,
      this.giftGiven,
      this.brandingPicPath,
      this.customerPicPath});

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    int? customerId = json['customer_id'];
    String? customerName = json['customer_name'];
    String? customerType = json['customer_type'];
    int? outletId = json['outlet_id'];
    int? locationId = json['company_id'];
    String? customerNumber = json['customer_number'];
    int? customerAge = json['customer_age'];
    String? customerEmail = json['customer_email'];
    String? maritalStatus = json['marital_status'];
    int? noOfKids = json['no_of_kids'];
    String? address = json['address'];
    String? cityName = json['cityname'];
    String? areaName = json['areaname'];
    String? pinCode = json['pincode'];
    int? isEnquired = json['is_enquired'];
    String? enquiryType = json['enquiry_type'];
    int? brandingDone = json['branding_done'];
    String? brandingType = json['branding_type'];
    int? salesDone = json['sales_done'];
    String? siteAddress = json['site_address'];
    String? siteCity = json['site_city'];
    String? giftGiven = json['gift_given'];
    String? brandingPicPath = json['branding_pic_path'];
    String? customerPicPath = json['customer_pic_path'];

    return CustomerModel(
      customerId: customerId,
      locationId: locationId,
      outletId: outletId,
      customerType: customerType,
      customerName: customerName,
      customerNumber: customerNumber,
      customerAge: customerAge,
      customerEmail: customerEmail,
      maritalStatus: maritalStatus,
      noOfKids: noOfKids,
      address: address,
      cityName: cityName,
      areaName: areaName,
      pinCode: pinCode,
      isEnquired: isEnquired,
      enquiryType: enquiryType,
      brandingType: brandingType,
      brandingDone: brandingDone,
      salesDone: salesDone,
      siteAddress: siteAddress,
      siteCity: siteCity,
      giftGiven: giftGiven,
      brandingPicPath: brandingPicPath,
      customerPicPath: customerPicPath,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dbtype'] = dbType;
    data['customer_id'] = customerId;
    data['company_id'] = locationId;
    data['customer_name'] = customerName;
    data['outlet_id'] = outletId;
    data['customer_type'] = customerType;
    data['customer_number'] = customerNumber;
    data['customer_age'] = customerAge;
    data['customer_email'] = customerEmail;
    data['marital_status'] = maritalStatus;
    data['no_of_kids'] = noOfKids;
    data['address'] = address;
    data['cityname'] = cityName;
    data['areaname'] = areaName;
    data['pincode'] = pinCode;
    data['is_enquired'] = isEnquired;
    data['enquiry_type'] = enquiryType ?? "";
    data['branding_done'] = brandingDone ?? 0;
    data['branding_type'] = brandingType ?? "";
    data['sales_done'] = salesDone ?? 0;
    data['site_address'] = siteAddress ?? "";
    data['site_city'] = siteCity ?? "";
    data['gift_given'] = giftGiven ?? "";
    data['branding_pic_path'] = brandingPicPath ?? "";
    data['customer_pic_path'] = customerPicPath ?? "";
    return data;
  }
}
