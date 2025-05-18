import 'package:auto_route/auto_route.dart';
import '/core/hive/models/product/product.dart';
import '/core/router/router.dart';
import 'package:flutter/material.dart';
import '/core/repositories/restaraunt/carts/carts.dart';
import 'package:hive_flutter/hive_flutter.dart';




class ProductTileCard extends StatelessWidget {
  const ProductTileCard({super.key, required this.product, required this.onAddToCart});

  final Product product;
  final VoidCallback onAddToCart;
  

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4, 
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 6), 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
      ), 
      clipBehavior: Clip.antiAlias,
      color: const Color.fromARGB(255, 17, 17, 17),
      child: InkWell(
        onTap: () {
          AutoRouter.of(context).push(ProductRoute(productId: product.id));
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
                          child: const Center(
                            child: Icon(Icons.restaurant, color: Colors.green, size: 70),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      color: const Color.fromARGB(255, 17, 17, 17),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: theme.textTheme.titleSmall?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.description ?? '',
                            style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 17, 17, 17),
                      border: Border(
                        top: BorderSide(color: Colors.white.withOpacity(0.1)),
                      ),
                    ),
                    child: Text(
                      '${product.price} ₽',
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.green),
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
                  color: theme.primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6, 
                      offset: const Offset(0, 3), 
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: onAddToCart,
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
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