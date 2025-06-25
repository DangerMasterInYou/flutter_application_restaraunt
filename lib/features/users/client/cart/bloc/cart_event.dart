// lib/features/cart/presentation/bloc/cart_event.dart
part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
}

class LoadCart extends CartEvent {
  const LoadCart();
  @override
  List<Object?> get props => [];
}

class AddItemToCart extends CartEvent {
  final CartItemRequestDTO item;
  const AddItemToCart(this.item);
  @override
  List<Object> get props => [item];
}

class UpdateItemQuantity extends CartEvent {
  final int cartItemId;
  final int newQuantity;
  const UpdateItemQuantity({required this.cartItemId, required this.newQuantity});
  @override
  List<Object> get props => [cartItemId, newQuantity];
}

class RemoveItemFromCart extends CartEvent {
  final int cartItemId;
  const RemoveItemFromCart(this.cartItemId);
  @override
  List<Object> get props => [cartItemId];
}