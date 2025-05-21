part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {}

class LoadCartList extends CartEvent {
  LoadCartList({this.completer});

  final Completer? completer;

  @override
  List<Object?> get props => [completer];
}

class RemoveFromCart extends CartEvent {
  RemoveFromCart({required this.item});

  final Cart item;

  @override
  List<Object?> get props => [item];
}

class AddToCart extends CartEvent {
  AddToCart({required this.cart});

  final Cart cart;

  @override
  List<Object?> get props => [cart];
}

class SubtractFromCart extends CartEvent {
  SubtractFromCart({required this.cart});

  final Cart cart;

  @override
  List<Object?> get props => [cart];
}

class DeleteItemFromCart extends CartEvent {
  DeleteItemFromCart({required this.cart});

  final Cart cart;

  @override
  List<Object?> get props => [cart];
}

class AddItemToCart extends CartEvent {
  AddItemToCart({required this.cart});

  final Cart cart;

  @override
  List<Object?> get props => [cart];
}

class SubtractItemFromCart extends CartEvent {
  SubtractItemFromCart({required this.cart});

  final Cart cart;

  @override
  List<Object?> get props => [cart];
}