part of 'orders_bloc.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object?> get props => [];
}

class OrdersInitial extends OrdersState {
  const OrdersInitial();
}

class OrdersLoading extends OrdersState {
  const OrdersLoading();
}

class OrdersLoaded extends OrdersState {
  const OrdersLoaded({required this.ordersList});

  final List<OrderResponseDTO> ordersList;

  @override
  List<Object?> get props => [ordersList];
}

class OrdersLoadingFailure extends OrdersState {
  const OrdersLoadingFailure({this.exception});

  final Object? exception;

  @override
  List<Object?> get props => [exception];
}

class OrdersDetailLoading extends OrdersState {
  const OrdersDetailLoading({this.ordersList = const []});

  final List<OrderResponseDTO> ordersList;

  @override
  List<Object?> get props => [ordersList];
}

class OrdersDetailLoaded extends OrdersState {
  const OrdersDetailLoaded({required this.order});

  final OrderResponseDTO order;

  @override
  List<Object?> get props => [order];
}

class OrdersDetailFailure extends OrdersState {
  const OrdersDetailFailure({
    required this.ordersList,
    this.exception,
  });

  final List<OrderResponseDTO> ordersList;
  final Object? exception;

  @override
  List<Object?> get props => [ordersList, exception];
}
