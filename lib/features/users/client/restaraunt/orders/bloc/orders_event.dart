part of 'orders_bloc.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrders extends OrdersEvent {
  LoadOrders({
    this.completer,
  });

  final Completer? completer;

  @override
  List<Object?> get props => super.props..add(completer);
}

class _UpdateOrdersFromWebSocket extends OrdersEvent {
  const _UpdateOrdersFromWebSocket(this.ordersList);

  final List<Order> ordersList;

  @override
  List<Object?> get props => [ordersList];
}

class _OrdersWebSocketErrorOccurred extends OrdersEvent {
  const _OrdersWebSocketErrorOccurred(this.error);
  final Object error;

  @override
  List<Object?> get props => [error];
}