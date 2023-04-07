import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sample_project/models/product_model.dart';
import 'package:sample_project/services/repositories/ecommerce_repositories/base_product_repository.dart';

class ProductRepository extends BaseProductRepository {
  final FirebaseFirestore _firebaseFirestore;

  ProductRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<List<ProductModel>> getAllProducts() async {
    List<ProductModel> products = [];

    FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        ProductModel product = ProductModel.fromMap(doc.data());
        products.add(product);
      }
    });

    return products;
  }
}
