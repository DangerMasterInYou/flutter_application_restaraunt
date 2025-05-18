part of 'cart_screen.dart';

@RoutePage()
class CartAddressScreen extends StatefulWidget {
  const CartAddressScreen({super.key});

  @override
  State<CartAddressScreen> createState() => _CartAddressScreenState();
}

class _CartAddressScreenState extends State<CartAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _houseController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _entranceController = TextEditingController();
  final _floorController = TextEditingController();
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _streetController.dispose();
    _houseController.dispose();
    _apartmentController.dispose();
    _entranceController.dispose();
    _floorController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Адрес доставки',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            
            TextFormField(
              controller: _streetController,
              decoration: const InputDecoration(
                labelText: 'Улица',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите улицу';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _houseController,
                    decoration: const InputDecoration(
                      labelText: 'Дом',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите номер дома';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _apartmentController,
                    decoration: const InputDecoration(
                      labelText: 'Квартира/Офис',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _entranceController,
                    decoration: const InputDecoration(
                      labelText: 'Подъезд',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _floorController,
                    decoration: const InputDecoration(
                      labelText: 'Этаж',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: 'Комментарий к заказу',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.comment),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.router.navigate(const CartItemsRoute());
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Назад'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.router.navigate(const CartPaymentRoute());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Продолжить'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}