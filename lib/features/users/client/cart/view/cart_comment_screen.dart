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
            const SizedBox(height: 24),
            
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
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Назад'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.router.navigate(const CartPaymentRoute());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
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