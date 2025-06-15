part of 'cart_screen.dart';

@RoutePage()
class CartPaymentScreen extends StatefulWidget {
  const CartPaymentScreen({super.key});

  @override
  State<CartPaymentScreen> createState() => _CartPaymentScreenState();
}

class _CartPaymentScreenState extends State<CartPaymentScreen> {
  String _selectedPaymentMethod = 'cash';

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Colors.black;
    final Color primaryTextColor = Colors.white;
    final Color secondaryTextColor = Colors.white70;
    final Color dividerColor = Colors.white38;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Способ оплаты',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: primaryTextColor,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          
          Card(
            color: backgroundColor,
            surfaceTintColor: backgroundColor,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              children: [
                RadioListTile<String>(
                  title: Text(
                    'Самовывоз',
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    'Оплата при получении заказа',
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 14,
                    ),
                  ),
                  activeColor: primaryTextColor,
                  value: 'cash',
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                    });
                  },
                ),
                Divider(height: 1, color: dividerColor),
                RadioListTile<String>(
                  title: Text(
                    'Онлайн оплата',
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    'Банковской картой через интернет',
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 14,
                    ),
                  ),
                  activeColor: primaryTextColor,
                  value: 'online',
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          Card(
            color: backgroundColor,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Информация о заказе',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: primaryTextColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Стоимость товаров:',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      Text('1200 ₽',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Доставка:',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      Text('Бесплатно',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ],
                  ),
                  Divider(color: dividerColor),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Итого:',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: primaryTextColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '1200 ₽',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: primaryTextColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.router.navigate(const CartAddressRoute());
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryTextColor),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Назад',
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Заказ успешно оформлен!'),
                        backgroundColor: backgroundColor,
                      ),
                    );
                    context.router.navigate(const MenuRoute());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryTextColor,
                    foregroundColor: backgroundColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Оформить заказ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
