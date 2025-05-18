import '../carts.dart';
abstract class AbstractCartsRepository {
  Future<List<Cart>> getCartsList();
  Future<void> postAddItemCart(Cart cart);
  Future<void> postSubtractItemCart(Cart cart);
  Future<void> postDeleteItemCart(Cart itemCart);
}
