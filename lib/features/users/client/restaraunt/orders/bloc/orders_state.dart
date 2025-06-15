part of 'orders_bloc.dart';

abstract class OrdersState extends Equatable {}

class OrdersInitial extends OrdersState {
  @override
  List<Object?> get props => [];
}

class OrdersLoading extends OrdersState {
  @override
  List<Object?> get props => [];
}

class OrdersLoaded extends OrdersState {
  OrdersLoaded({
    required this.ordersList,
  });

  final List<Order> ordersList;

  @override
  List<Object?> get props => [ordersList];
}

class OrdersLoadingFailure extends OrdersState {
  OrdersLoadingFailure({
    this.exception,
  });

  final Object? exception;

  @override
  List<Object?> get props => [exception];
}

class OrdersWebSocketFailure extends OrdersState {
  OrdersWebSocketFailure({
    this.exception,
  });

  final Object? exception;

  @override
  List<Object?> get props => [exception];
}