import '../product_variant.dart';

abstract class AbstractProductVariantRepository {
  Future<List<ProductVariant>> getProductVariantList();
  Future<ProductVariant> getProductVariant(int productVariantId);
  Future<ProductVariant> postCreateProductVariant(ProductVariantCreateDTO dto);
  Future<ProductVariant> patchProductVariant(
      int productVariantId, ProductVariantPatchDTO dto);
  Future<void> deleteHardProductVariant(int productVariantId);
  Future<void> deleteSoftProductVariant(int productVariantId);
  Future<void> postRestoreProductVariant(int productVariantId);
}
