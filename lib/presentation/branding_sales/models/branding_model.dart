class BrandingModel {
  int? brandingId;
  String? dbType;
  String? brandingType;
  int? locationId;
  int? variableId;
  String? productName;
  String? productUnit;
  int? quantity;

  BrandingModel(
      {this.brandingId,
      this.dbType,
      this.brandingType,
      this.locationId,
      this.variableId,
      this.productName,
      this.productUnit,
      this.quantity});

  factory BrandingModel.fromJsonCustomer(Map<String, dynamic> json) {
    String? dbType = json['dbtype'];
    int? brandingId = json['branding_id'];
    String? brandingType = json['branding_type'];
    int? locationId = json['company_id'];
    int? customerId = json['customer_id'];
    String? productName = json['product_name'];
    String? productUnit = json['product_unit'];
    int? quantity = json['quantity'];

    return BrandingModel(
        dbType: dbType,
        brandingId: brandingId,
        brandingType: brandingType,
        locationId: locationId,
        variableId: customerId,
        productName: productName,
        productUnit: productUnit,
        quantity: quantity);
  }

  factory BrandingModel.fromJsonOutlet(Map<String, dynamic> json) {
    String? dbType = json['dbtype'];
    int? brandingId = json['branding_id'];
    String? brandingType = json['branding_type'];
    int? locationId = json['company_id'];
    int? customerId = json['outlet_id'];
    String? productName = json['product_name'];
    String? productUnit = json['product_unit'];
    int? quantity = json['quantity'];

    return BrandingModel(
        dbType: dbType,
        brandingId: brandingId,
        brandingType: brandingType,
        locationId: locationId,
        variableId: customerId,
        productName: productName,
        productUnit: productUnit,
        quantity: quantity);
  }

  Map<String, dynamic> toJsonCustomer() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dbtype'] = dbType;
    data['branding_id'] = brandingId;
    data['branding_type'] = brandingType;
    data['company_id'] = locationId;
    data['customer_id'] = variableId;
    data['product_name'] = productName;
    data['product_unit'] = productUnit;
    data['quantity'] = quantity;
    return data;
  }

  Map<String, dynamic> toJsonOutlet() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['dbtype'] = dbType;
    data['branding_id'] = brandingId;
    data['branding_type'] = brandingType;
    data['company_id'] = locationId;
    data['outlet_id'] = variableId;
    data['product_name'] = productName;
    data['product_unit'] = productUnit;
    data['quantity'] = quantity;
    return data;
  }
}
