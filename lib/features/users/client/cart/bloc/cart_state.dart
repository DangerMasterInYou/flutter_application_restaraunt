part of 'cart_bloc.dart';

abstract class CartState extends Equatable {}

class CartInitial extends CartState {
  @override
  List<Object?> get props => [];
}

class CartLoading extends CartState {
  @override
  List<Object?> get props => [];
}

class LoginInvalid extends CartState {
  LoginInvalid();

  @override
  List<Object?> get props => [];
}

class CartLoaded extends CartState {
  CartLoaded({
    required this.cartList,
  });

  final List<Cart> cartList;

  @override
  List<Object?> get props => [cartList];
}

class CartLoadingFailure extends CartState {
  CartLoadingFailure({
    this.exception,
  });

  final Object? exception;

  @override
  List<Object?> get props => [exception];
}