class ProductModel {
  final String? name;
  final String? price;
  final String? imageUrl;

  ProductModel({this.name, this.price, this.imageUrl});

  factory ProductModel.fromMap(Map<String, dynamic>? data) {
    return ProductModel(
      name: data?['name'] as String?,
      price: data?['price'] as String?,
      imageUrl: data?['imageUrl'] as String?,
    );
  }
}
