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
  
  bool _addressValidated = false;

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
  
  void _onAddressValidated() {
    setState(() {
      _addressValidated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Адрес доставки',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            
            YandexMapWidget(
              streetController: _streetController,
              houseController: _houseController,
              apartmentController: _apartmentController,
              entranceController: _entranceController,
              floorController: _floorController,
              commentController: _commentController,
              formKey: _formKey,
              onAddressValidated: _onAddressValidated,
            ),
            
            const SizedBox(height: 24),
            
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _apartmentController,
                    decoration: const InputDecoration(
                      labelText: 'Квартира/Офис',
                      border: OutlineInputBorder(),
                    ),
                    style: theme.textTheme.labelSmall,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _entranceController,
                    decoration: const InputDecoration(
                      labelText: 'Подъезд',
                      border: OutlineInputBorder(),
                    ),
                    style: theme.textTheme.labelSmall,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _floorController,
                    decoration: const InputDecoration(
                      labelText: 'Этаж',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    style: theme.textTheme.labelSmall,
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
              style: theme.textTheme.labelSmall,
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
                        if (!_addressValidated) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Пожалуйста, подтвердите адрес')),
                          );
                          return;
                        }
                        
                        final addressData = {
                          'address': _streetController.text + ', ' + _houseController.text,
                          'apartment': _apartmentController.text,
                          'entrance': _entranceController.text,
                          'floor': _floorController.text,
                          'comment': _commentController.text,
                        };
                        
                        print('Данные адреса: $addressData');
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