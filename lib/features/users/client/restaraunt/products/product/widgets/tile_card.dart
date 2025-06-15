import 'package:auto_route/auto_route.dart';
import '/core/hive/models/product/product.dart';
import '/core/router/router.dart';
import 'package:flutter/material.dart';
import '/core/repositories/users/client/restaraunt/carts/carts.dart';
import 'package:hive_flutter/hive_flutter.dart';




class ProductTileCard extends StatelessWidget {
  const ProductTileCard({super.key, required this.product, required this.onAddToCart});

  final Product product;
  final VoidCallback onAddToCart;
  

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: () {
          AutoRouter.of(context).push(ProductRoute(productName: product.name));
        },
        child: Stack(
          children: [
            Container(
              color: Colors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 5,
                    child: Image.network(
                      product.fullImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[900],
                          child: Center(
                            child: Icon(Icons.restaurant, color: theme.primaryColor.withOpacity(0.6), size: 70),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleSmall?.copyWith(color: Colors.white, fontSize: 22),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Flexible(
                            child: Text(
                              product.description ?? '',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.8)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      // color: theme.cardColor,
                      border: Border(
                        top: BorderSide(color: Colors.white.withOpacity(0.15)),
                      ),
                    ),
                    child: Text(
                      '${product.price} ₽',
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 12, 
              right: 12, 
              child: Container(
                decoration: BoxDecoration(
                  color: theme.elevatedButtonTheme.style?.backgroundColor?.resolve({}),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8, 
                      offset: const Offset(0, 4), 
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: onAddToCart,
                  icon: Icon(
                    Icons.add,
                    color: theme.elevatedButtonTheme.style?.foregroundColor?.resolve({}),
                    size: 32, 
                  ),
                  padding: const EdgeInsets.all(12), 
                  constraints: const BoxConstraints(
                    minWidth: 48, 
                    minHeight: 48, 
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}