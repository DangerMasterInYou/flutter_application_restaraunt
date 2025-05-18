part of 'cart_screen.dart';

@RoutePage()
class CartItemsScreen extends StatefulWidget {
  const CartItemsScreen({super.key});

  @override
  State<CartItemsScreen> createState() => _CartItemsScreenState();
}

class _CartItemsScreenState extends State<CartItemsScreen> {
  late final CartBloc _cartBloc;

  @override
  void initState() {
    super.initState();
    _cartBloc = context.read<CartBloc>();
    _cartBloc.add(LoadCartList());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BlocBuilder<CartBloc, CartState>(
      bloc: _cartBloc,
      builder: (context, state) {
        if (state is CartLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CartLoadingFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Ошибка загрузки: ${state.exception}', style: theme.textTheme.titleMedium),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:(){_cartBloc.add(LoadCartList());},
                  child: const Text('Попробовать снова'),
                ),
              ],
            ),
          );
        } else if (state is CartLoaded) {
          final cartItems = state.cartList;
          
          if (cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.green),
                  const SizedBox(height: 16),
                  Text('Ваша корзина пуста', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.router.popForced(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Вернуться в меню'),
                  ),
                ],
              ),
            );
          }
          
          double totalPrice = 0;
          for (var item in cartItems) {
            totalPrice += item.price * item.count;
          }
          
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final cart = cartItems[index];
                    return CartTileCard(
                      cart: cart,
                      onSubtractToBacket: () {
                        //_cartBloc.add(SubtractItemFromCart(cart: cart));
                      },
                      onAddToBacket: () {
                        //_cartBloc.add(AddItemToCart(cart: cart));
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Итого:', style: theme.textTheme.titleMedium),
                        Text(
                          '${totalPrice.toStringAsFixed(2)} ₽',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          context.router.navigate(const CartAddressRoute());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Продолжить оформление'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}