// lib/features/cart/presentation/bloc/cart_state.dart
part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();
}

class CartInitial extends CartState {
  @override
  List<Object?> get props => [];
}

class CartLoading extends CartState {
  @override
  List<Object?> get props => [];
}

class CartLoaded extends CartState {
  // Теперь состояние хранит весь ответ
  final CartResponseDTO cartResponse;
  const CartLoaded({required this.cartResponse});
  @override
  List<Object?> get props => [cartResponse];
}

class CartLoadingFailure extends CartState {
  final Object? exception;
  const CartLoadingFailure({this.exception});
  @override
  List<Object?> get props => [exception];
}