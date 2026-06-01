part of 'orders_bloc.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrders extends OrdersEvent {
  const LoadOrders();
}

class LoadOrderDetail extends OrdersEvent {
  const LoadOrderDetail(this.orderId);

  final int orderId;

  @override
  List<Object?> get props => [orderId];
}
