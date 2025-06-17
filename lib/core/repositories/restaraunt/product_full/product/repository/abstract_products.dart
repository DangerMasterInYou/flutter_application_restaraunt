import '../product.dart';

abstract class AbstractProductRepository {
  Future<List<Product>> getProductList();
  Future<Product> getProduct(int productId);
  Future<Product> postCreateProduct(ProductCreateDTO dto);
  Future<Product> patchProduct(int productId, ProductPatchDTO dto);
  Future<void> deleteHardProduct(int productId);
  Future<void> deleteSoftProduct(int productId);
  Future<void> postRestoreProduct(int productId);
}
