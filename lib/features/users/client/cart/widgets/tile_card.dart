import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '/core/router/router.dart';
import '/core/hive/models/models.dart';
import '/core/repositories/restaraunt/restaraunt.dart';

class CartTileCard extends StatelessWidget {
  const CartTileCard({
    super.key, 
    required this.cart, 
    required this.onSubtractToBacket, 
    required this.onAddToBacket,
    required this.onDeleteFromBacket,
  });

  final Cart cart;
  final VoidCallback onSubtractToBacket;
  final VoidCallback onAddToBacket;
  final VoidCallback onDeleteFromBacket;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalPrice = cart.price * cart.count;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      color: const Color.fromARGB(255, 40, 40, 40),
      child: InkWell(
        onTap: () {
          context.router.push(ProductRoute(productId: cart.id));
        },
        child: SizedBox(
          height: isSmallScreen ? 140 : 160,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: isSmallScreen ? 2 : 3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      cart.fullImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[800],
                          child: Center(
                            child: Icon(
                              Icons.restaurant,
                              size: 50,
                              color: Colors.green,
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          '${totalPrice.toStringAsFixed(0)} ₽',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: isSmallScreen ? 3 : 4,
                child: Padding(
                  padding: EdgeInsets.all(isSmallScreen ? 8.0 : 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              cart.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: isSmallScreen ? 16 : 18,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white54, size: 20),
                            onPressed: onDeleteFromBacket,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 24,
                              minHeight: 24,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Цена: ${cart.price} ₽',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                          ),
                          _buildCountControls(theme, isSmallScreen),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountControls(ThemeData theme, bool isSmallScreen) {
    final buttonSize = isSmallScreen ? 32.0 : 36.0;
    
    return Row(
      children: [
        _buildCountButton(
          icon: Icons.remove,
          onPressed: onSubtractToBacket,
          theme: theme,
          size: buttonSize,
        ),
        Container(
          width: buttonSize,
          height: buttonSize,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade700,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              '${cart.count}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: isSmallScreen ? 14 : 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        
        _buildCountButton(
          icon: Icons.add,
          onPressed: onAddToBacket,
          theme: theme,
          size: buttonSize,
        ),
      ],
    );
  }

  Widget _buildCountButton({
    required IconData icon,
    required VoidCallback onPressed,
    required ThemeData theme,
    required double size,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: Colors.white,
          size: size * 0.5,
        ),
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(
          minWidth: size,
          minHeight: size,
        ),
      ),
    );
  }
}
