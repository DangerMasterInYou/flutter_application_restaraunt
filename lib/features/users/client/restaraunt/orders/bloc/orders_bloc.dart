import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '/core/repositories/users/client/restaraunt/orders/orders.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc(this.ordersRepository) : super(const OrdersInitial()) {
    on<LoadOrders>(_onLoadOrders);
    on<LoadOrderDetail>(_onLoadOrderDetail);
  }

  final AbstractOrdersRepository ordersRepository;

  Future<void> _onLoadOrders(
    LoadOrders event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      emit(const OrdersLoading());
      final orders = await ordersRepository.getOrdersList();
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(OrdersLoaded(ordersList: orders));
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      emit(OrdersLoadingFailure(exception: e));
    }
  }

  Future<void> _onLoadOrderDetail(
    LoadOrderDetail event,
    Emitter<OrdersState> emit,
  ) async {
    final previous = state;
    try {
      emit(OrdersDetailLoading(
        ordersList: previous is OrdersLoaded ? previous.ordersList : const [],
      ));
      final order = await ordersRepository.getOrder(event.orderId);
      emit(OrdersDetailLoaded(order: order));
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      emit(OrdersDetailFailure(
        exception: e,
        ordersList: previous is OrdersLoaded ? previous.ordersList : const [],
      ));
    }
  }
}
