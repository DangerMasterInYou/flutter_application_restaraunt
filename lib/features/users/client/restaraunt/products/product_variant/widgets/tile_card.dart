import 'package:flutter/material.dart';
import '/core/repositories/users/client/restaraunt/carts/carts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/core/repositories/users/client/restaraunt/products/products.dart';
import '/core/hive/models/product_full/product_variant/product_variant.dart';
import '/core/hive/models/product_full/product/product.dart';
import '/core/hive/models/product_full/category/category.dart';

/// DTO для передачи всех нужных данных в карточку варианта продукта
class ProductVariantTileData {
  final int id;
  final String name; // "$Product.name $ProductVariant.name"
  final String description;
  final int price;
  final String? imageUrl;
  final int? weightG;
  final int? volumeMl;
  final bool isAvailable;
  final String categoryName;

  ProductVariantTileData({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    this.weightG,
    this.volumeMl,
    required this.isAvailable,
    required this.categoryName,
  });

  /// Собирает данные по связям: ProductVariant -> Product -> Category
  factory ProductVariantTileData.fromEntities({
    required ProductVariant variant,
    required Product product,
    required Category category,
  }) {
    return ProductVariantTileData(
      id: variant.id,
      name: '${product.name} ${variant.name}',
      description: variant.description,
      price: variant.price,
      imageUrl: variant.imageUrl,
      categoryName: category.name,
      isAvailable: variant.isAvailable,
    );
  }
}

class ProductVariantTileCard extends StatelessWidget {
  const ProductVariantTileCard({
    super.key,
    required this.data,
    required this.onAddToCart,
  });

  final ProductVariantTileData data;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: null,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (data.imageUrl != null && data.imageUrl!.isNotEmpty)
                Center(
                  child: Image.network(
                    data.imageUrl!,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
              const SizedBox(height: 8),
              Text(data.name, style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(data.description, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 8),
              Text('Цена: ${data.price} ₽', style: theme.textTheme.bodyMedium),
              if (data.weightG != null)
                Text('Вес: ${data.weightG} г',
                    style: theme.textTheme.bodySmall),
              if (data.volumeMl != null)
                Text('Объем: ${data.volumeMl} мл',
                    style: theme.textTheme.bodySmall),
              Text('Категория: ${data.categoryName}',
                  style: theme.textTheme.bodySmall),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: data.isAvailable ? onAddToCart : null,
                child: Text(
                    data.isAvailable ? 'Добавить в корзину' : 'Нет в наличии'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
