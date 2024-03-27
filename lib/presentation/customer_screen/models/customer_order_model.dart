class CustomerOrderModel {
  String? dbType;
  int? locationId;
  int? customerId;
  String? productName;
  String? productUnit;
  int? quantity;

  CustomerOrderModel(
      {this.dbType,
      this.locationId,
      this.customerId,
      this.productName,
      this.productUnit,
      this.quantity});

  CustomerOrderModel.fromJson(Map<String, dynamic> json) {
    dbType = json['dbtype'];
    locationId = json['company_id'];
    customerId = json['customer_id'];
    productName = json['product_name'];
    productUnit = json['product_unit'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dbtype'] = dbType;
    data['company_id'] = locationId;
    data['customer_id'] = customerId;
    data['product_name'] = productName;
    data['product_unit'] = productUnit;
    data['quantity'] = quantity;
    return data;
  }
}
