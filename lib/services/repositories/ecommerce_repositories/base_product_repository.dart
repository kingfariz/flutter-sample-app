import 'package:sample_project/models/product_model.dart';

abstract class BaseProductRepository {
  Future<List<ProductModel>> getAllProducts();
}
