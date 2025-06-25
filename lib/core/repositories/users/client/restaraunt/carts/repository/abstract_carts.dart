// lib/features/cart/domain/repositories/abstract_cart_repository.dart
import '../carts.dart';

abstract class AbstractCartRepository {
  /// GET /cart
  Future<CartResponseDTO> getCart();

  /// POST /cart/items
  Future<CartResponseDTO> addItemToCart(CartItemRequestDTO item);

  /// PATCH /cart/items/{cart_item_id}
  Future<CartResponseDTO> updateItemQuantity(int cartItemId, int newQuantity);

  /// DELETE /cart/items/{cart_item_id}
  Future<CartResponseDTO> deleteItemFromCart(int cartItemId);
}