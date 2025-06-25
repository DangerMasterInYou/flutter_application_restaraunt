// lib/features/cart/presentation/view/cart_items_screen.dart


part of 'cart_screen.dart';

@RoutePage()
class CartItemsScreen extends StatefulWidget {
  const CartItemsScreen({super.key});

  @override
  State<CartItemsScreen> createState() => _CartItemsScreenState();
}

class _CartItemsScreenState extends State<CartItemsScreen> {
  @override
  void initState() {
    super.initState();
    // BLoC уже предоставлен родительским виджетом (CartScreen),
    // поэтому мы можем безопасно его читать.
    context.read<CartBloc>().add(const LoadCart());
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold здесь больше не нужен, так как он есть в родительском CartScreen
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoading || state is CartInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CartLoadingFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Ошибка загрузки: ${state.exception}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<CartBloc>().add(const LoadCart()),
                  child: const Text('Попробовать снова'),
                ),
              ],
            ),
          );
        }
        if (state is CartLoaded) {
          final cartResponse = state.cartResponse;
          if (cartResponse.items.isEmpty) {
            return _buildEmptyCart(context);
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartResponse.items.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartResponse.items[index];
                    return CartTileCard(
                      cartItem: cartItem,
                      onAdd: () {
                        context.read<CartBloc>().add(UpdateItemQuantity(
                              cartItemId: cartItem.id,
                              newQuantity: cartItem.quantity + 1,
                            ));
                      },
                      onSubtract: () {
                        if (cartItem.quantity > 1) {
                          context.read<CartBloc>().add(UpdateItemQuantity(
                                cartItemId: cartItem.id,
                                newQuantity: cartItem.quantity - 1,
                              ));
                        } else {
                          context.read<CartBloc>().add(RemoveItemFromCart(cartItem.id));
                        }
                      },
                      onDelete: () {
                        context.read<CartBloc>().add(RemoveItemFromCart(cartItem.id));
                      },
                    );
                  },
                ),
              ),
              _buildBottomBar(context, cartResponse.totalPrice),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.green),
          const SizedBox(height: 16),
          Text('Ваша корзина пуста', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.router.pop(), // Просто выходим из корзины
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            child: const Text('Вернуться в меню'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, int totalPrice) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Итого:', style: Theme.of(context).textTheme.titleMedium),
              Text('$totalPrice ₽', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Переключаем на следующую вкладку
                AutoTabsRouter.of(context).setActiveIndex(1);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
              child: const Text('Продолжить'),
            ),
          ),
        ],
      ),
    );
  }
}