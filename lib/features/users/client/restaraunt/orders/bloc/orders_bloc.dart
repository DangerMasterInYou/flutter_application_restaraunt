// import 'dart:async';
// import 'dart:convert';

// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get_it/get_it.dart';
// import 'package:talker_flutter/talker_flutter.dart';


// import '/core/repositories/users/client/restaraunt/orders/orders.dart';
// import '/core/hive/models/order/order.dart';


// part 'orders_event.dart';
// part 'orders_state.dart';

// class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
//   OrdersBloc(this.ordersRepository) : super(OrdersInitial()) {
//     on<LoadOrders>(_load);
//     on<_UpdateOrdersFromWebSocket>(_onUpdateOrdersFromWebSocket);
//     on<_OrdersWebSocketErrorOccurred>(_onOrdersWebSocketErrorOccurred);
//   }

//   final AbstractOrdersRepository ordersRepository;
//   StreamSubscription? _ordersSubscription;

//   Future<void> _load(
//     LoadOrders event,
//     Emitter<OrdersState> emit,
//   ) async {
//     try {
//       emit(OrdersLoading());
//       final ordersList = await ordersRepository.getOrdersList();
//       emit(OrdersLoaded(ordersList: ordersList));
//       ordersRepository.initiateWebSocketConnection();
//       _ordersSubscription?.cancel();
//       _ordersSubscription = ordersRepository.getOrdersStream().listen(
//         (updatedOrders) {
//           if (!emit.isDone) {
//             add(_UpdateOrdersFromWebSocket(updatedOrders));
//           }
//         },
//         onError: (error, stackTrace) {
//           GetIt.I<Talker>().handle(error, stackTrace, 'Error from orders stream');
//           if (!isClosed) {
//             add(_OrdersWebSocketErrorOccurred(error));
//           }
//         },
//       );
//     } catch (e, st) {
//       emit(OrdersLoadingFailure(exception: e));
//       GetIt.I<Talker>().handle(e, st);
//     } finally {
//       event.completer?.complete();
//     }
//   }

//   void _onUpdateOrdersFromWebSocket(
//     _UpdateOrdersFromWebSocket event,
//     Emitter<OrdersState> emit,
//   ) {
//     if (state is OrdersLoaded || state is OrdersLoading) {
//         final sortedOrders = List<Order>.from(event.ordersList)
//           ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
//         emit(OrdersLoaded(ordersList: sortedOrders));
//     } else {
//         final sortedOrders = List<Order>.from(event.ordersList)
//           ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
//         emit(OrdersLoaded(ordersList: sortedOrders));
//     }
//   }

//   @override
//   Future<void> close() {
//     _ordersSubscription?.cancel();
//     return super.close();
//   }

//   void _onOrdersWebSocketErrorOccurred(
//     _OrdersWebSocketErrorOccurred event,
//     Emitter<OrdersState> emit,
//   ) {
//     emit(OrdersWebSocketFailure(exception: event.error));
//   }
// }