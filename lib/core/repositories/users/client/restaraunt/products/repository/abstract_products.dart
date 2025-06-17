import '/core/hive/models/product_full/product/product.dart';
import 'products.dart';

abstract class AbstractProductsRepository {
  Future<List<Product>> getProductsList();
  Future<Product> getProduct(int productId);
}
