import 'package:hive_flutter/hive_flutter.dart';
import '/core/hive/models/product_full/product_variant/product_variant.dart';
import '/core/hive/models/product_full/product/product.dart';
import '/core/hive/models/product_full/category/category.dart';
import '/features/users/client/restaraunt/products/product_variant/widgets/tile_card.dart';

/// Универсальные функции для получения ProductVariantTileData и связанных сущностей

/// Получить ProductVariant по id
ProductVariant? getProductVariantById(int variantId) {
  final box = Hive.box<ProductVariant>('product_variants_box');
  return box.get(variantId);
}

/// Получить Product по id
Product? getProductById(int productId) {
  final box = Hive.box<Product>('products_box');
  return box.get(productId);
}

/// Получить Category по id
Category? getCategoryById(int categoryId) {
  final box = Hive.box<Category>('categories_box');
  return box.get(categoryId);
}

/// Собрать ProductVariantTileData по id варианта
ProductVariantTileData? getProductVariantTileDataByVariantId(int variantId) {
  final variant = getProductVariantById(variantId);
  if (variant == null) return null;
  final product = getProductById(variant.productId);
  if (product == null) return null;
  final category = getCategoryById(product.categoryId);
  if (category == null) return null;
  return ProductVariantTileData.fromEntities(
    variant: variant,
    product: product,
    category: category,
  );
}

/// Пример: получить список всех ProductVariantTileData
List<ProductVariantTileData> getAllProductVariantTileData() {
  final variantBox = Hive.box<ProductVariant>('product_variants_box');
  final productBox = Hive.box<Product>('products_box');
  final categoryBox = Hive.box<Category>('categories_box');
  final List<ProductVariantTileData> result = [];
  for (final variant in variantBox.values) {
    final product = productBox.get(variant.productId);
    if (product == null) continue;
    final category = categoryBox.get(product.categoryId);
    if (category == null) continue;
    result.add(ProductVariantTileData.fromEntities(
      variant: variant,
      product: product,
      category: category,
    ));
  }
  return result;
}
