import '/core/hive/models/product/product.dart';

abstract class AbstractProductsRepository {
  Future<List<Product>> getProductsList();
  Future<Product> getProduct(int productId);
}
