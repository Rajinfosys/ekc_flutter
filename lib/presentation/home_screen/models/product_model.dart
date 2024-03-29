class ProductModel {
  int? productId;
  String? productName;

  ProductModel({this.productId, this.productName});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    int? productId = json['productid'];
    String? productName = json['product_name'];
    return ProductModel(productId: productId, productName: productName);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['productid'] = productId;
    data['product_name'] = productName;
    return data;
  }
}
