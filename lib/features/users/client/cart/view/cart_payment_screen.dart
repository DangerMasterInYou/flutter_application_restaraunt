// lib/features/users/client/cart/view/cart_payment_screen.dart
part of 'cart_screen.dart';

@RoutePage()
class CartPaymentScreen extends StatefulWidget {
  const CartPaymentScreen({super.key});

  @override
  State<CartPaymentScreen> createState() => _CartPaymentScreenState();
}

class _CartPaymentScreenState extends State<CartPaymentScreen> {
  String _selectedPaymentMethod = 'cash';
  Timer? _loadingTimer;
  bool _showRetryButton = false;
  bool _wasPlacingOrder = false;

  @override
  void initState() {
    super.initState();
    _startLoadingTimer();
  }

  void _startLoadingTimer() {
    _loadingTimer?.cancel();
    setState(() {
      _showRetryButton = false;
    });
    _loadingTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showRetryButton = true;
        });
      }
    });
  }

  void _cancelTimer() {
    _loadingTimer?.cancel();
    if (mounted) {
      setState(() {
        _showRetryButton = false;
      });
    }
  }

  @override
  void dispose() {
    _loadingTimer?.cancel();
    super.dispose();
  }

  void _retryLoad() {
    _startLoadingTimer();
    context.read<CartBloc>().add(const LoadCart());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        // FIX: Отменяем таймер, когда корзина успешно загружена
        if (state is CartLoaded) {
          _cancelTimer();
          _wasPlacingOrder = false;
        }
        if (state is CartPlacingOrder) {
          _wasPlacingOrder = true;
        }
        if (state is CartLoadingFailure && _wasPlacingOrder) {
          _wasPlacingOrder = false;
          // Показываем причину ошибки
          String errorMsg = state.exception?.toString() ?? 'Неизвестная ошибка';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка оформления: $errorMsg'),
              backgroundColor: Colors.red,
            ),
          );
          // Перезагружаем корзину, чтобы вернуться в рабочее состояние
          context.read<CartBloc>().add(const LoadCart());
        }
        if (state is CartOrderPlaced) {
          _wasPlacingOrder = false;
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Заказ ${state.order.displayNumber} оформлен'),
            ),
          );
          context.router.popUntilRoot();
          context.router.replace(const MenuRoute());
        }
      },
      builder: (context, state) {
        // Если идет оформление заказа – показываем индикатор
        if (state is CartPlacingOrder) {
          return const Center(child: CircularProgressIndicator());
        }

        // Если корзина не загружена и не показана кнопка повтора – ждём
        if (state is! CartLoaded && !_showRetryButton) {
          return const Center(child: CircularProgressIndicator());
        }

        // Если таймер сработал, а корзина всё ещё не загружена – показываем кнопку повтора
        if (_showRetryButton && state is! CartLoaded) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Не удалось загрузить данные заказа.'),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Попробовать снова'),
                  onPressed: _retryLoad,
                ),
              ],
            ),
          );
        }

        // Корзина загружена – отображаем форму оплаты
        final cartResponse = (state as CartLoaded).cartResponse;
        final customerName = state.customerName;
        final customerPhone = state.customerPhone;

        // FIX: Блокируем кнопку, если контактные данные не заполнены
        final bool canPlaceOrder = customerName != null &&
            customerName.trim().isNotEmpty &&
            customerPhone != null &&
            customerPhone.trim().isNotEmpty &&
            cartResponse.items.isNotEmpty;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Способ оплаты',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 24),
              _buildPaymentMethodSelector(),
              const SizedBox(height: 24),
              _buildOrderSummary(context, cartResponse.totalPrice),
              const SizedBox(height: 24),
              if (!canPlaceOrder)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Заполните контактные данные на предыдущем шаге',
                    style: TextStyle(color: Colors.orange[300]),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: canPlaceOrder
                      ? () {
                          context.read<CartBloc>().add(
                                PlaceOrder(
                                    paymentMethod: _selectedPaymentMethod),
                              );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Оформить заказ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Column(
      children: [
        RadioListTile<String>(
          title: const Text('Оплата при получении'),
          value: 'cash',
          groupValue: _selectedPaymentMethod,
          onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
        ),
        RadioListTile<String>(
          title: const Text('Онлайн оплата'),
          value: 'online',
          groupValue: _selectedPaymentMethod,
          onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
        ),
      ],
    );
  }

  Widget _buildOrderSummary(BuildContext context, int totalPrice) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Информация о заказе',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Стоимость товаров:'),
                Text('$totalPrice ₽'),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Итого:',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                Text('$totalPrice ₽',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
