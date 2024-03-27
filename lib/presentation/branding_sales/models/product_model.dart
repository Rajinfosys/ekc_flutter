class ProductModel {
  int? productId;
  String? dbType;
  int? locationId;
  int? customerId;
  String? productName;
  String? productUnit;
  int? quantity;

  ProductModel(
      {this.productId,
      this.dbType,
      this.locationId,
      this.customerId,
      this.productName,
      this.productUnit,
      this.quantity});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    int? productId = json['order_id'];
    String? dbType = json['dbtype'];
    int? locationId = json['company_id'];
    int? customerId = json['customer_id'];
    String? productName = json['product_name'];
    String? productUnit = json['product_unit'];
    int? quantity = json['quantity'];

    return ProductModel(
        productId: productId,
        dbType: dbType,
        locationId: locationId,
        customerId: customerId,
        productName: productName,
        productUnit: productUnit,
        quantity: quantity);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dbtype'] = dbType;
    data['order_id'] = productId;
    data['company_id'] = locationId;
    data['customer_id'] = customerId;
    data['product_name'] = productName;
    data['product_unit'] = productUnit;
    data['quantity'] = quantity;
    return data;
  }
}
