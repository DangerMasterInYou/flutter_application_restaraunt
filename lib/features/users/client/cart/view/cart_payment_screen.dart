// lib/features/cart/presentation/view/cart_payment_screen.dart

part of 'cart_screen.dart';


@RoutePage()
class CartPaymentScreen extends StatefulWidget {
  const CartPaymentScreen({super.key});

  @override
  State<CartPaymentScreen> createState() => _CartPaymentScreenState();
}

class _CartPaymentScreenState extends State<CartPaymentScreen> {
  String _selectedPaymentMethod = 'cash';
  
  // ИСПРАВЛЕНО: Таймер для отслеживания долгой загрузки
  Timer? _loadingTimer;
  bool _showRetryButton = false;

  @override
  void initState() {
    super.initState();
    _startLoadingTimer();
  }
  
  void _startLoadingTimer() {
    // Сбрасываем предыдущие состояния
    _loadingTimer?.cancel();
    setState(() {
      _showRetryButton = false;
    });

    // Запускаем новый таймер
    _loadingTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showRetryButton = true;
        });
      }
    });
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
      listener: (context, state) {
        // Когда данные успешно загружены, отменяем таймер
        if (state is CartLoaded) {
          _loadingTimer?.cancel();
          if (_showRetryButton) {
            setState(() {
              _showRetryButton = false;
            });
          }
        }
      },
      builder: (context, state) {
        // Если идет загрузка или ошибка, но кнопка "Повторить" еще не показана
        if (state is! CartLoaded && !_showRetryButton) {
          return const Center(child: CircularProgressIndicator());
        }
        
        // Если таймер сработал и нужно показать кнопку "Повторить"
        if (_showRetryButton) {
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

        // Если все загружено успешно (state is CartLoaded)
        final cartResponse = (state as CartLoaded).cartResponse;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Способ оплаты', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 24),
              _buildPaymentMethodSelector(),
              const SizedBox(height: 24),
              _buildOrderSummary(context, cartResponse.totalPrice),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Здесь будет логика оформления заказа
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Заказ успешно оформлен!')),
                    );
                    context.router.popUntilRoot(); // Возвращаемся на самый первый экран
                    context.router.replace(const MenuRoute()); // и заменяем его на Меню
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Оформить заказ', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentMethodSelector() {
    // ... этот код остается без изменений ...
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
    // ... этот код остается без изменений ...
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Информация о заказе', style: Theme.of(context).textTheme.titleMedium),
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
                Text('Итого:', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text('$totalPrice ₽', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}