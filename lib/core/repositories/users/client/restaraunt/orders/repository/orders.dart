// import 'package:dio/dio.dart';
// import 'package:get_it/get_it.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:talker_flutter/talker_flutter.dart';

// import '/core/repositories/services/jwt_tokens/abstract_jwt_tokens_repository.dart';
// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/foundation.dart' show kIsWeb;

// // Conditional import for web_socket_channel
// import 'package:web_socket_channel/io.dart'
//     if (dart.library.html) 'package:web_socket_channel/html.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// import '../orders.dart';

// class OrderRepository implements AbstractOrderRepository {
//   OrderRepository({
//     required this.dio,
//     required this.orderBox,
//     required this.apiSiteUrl,
//   });

//   final Dio dio;
//   final Box<Order> orderBox;
//   final String apiSiteUrl;
//   static String? get accessToken =>
//       GetIt.I<AbstractJWTTokensRepository>().getAccessToken();

//   WebSocketChannel? _channel;
//   StreamSubscription? _channelSubscription;
//   final _ordersStreamController = StreamController<List<Order>>.broadcast();

//   @override
//   Future<List<Order>> getOrderList() async {
//     var ordersList = orderBox.values.toList();
//     // try {
//     //   // ordersList = await _fetchOrderListFromApi(); // Removed as /orders is not a server endpoint
//     //   // final ordersMap = {for (var e in ordersList) e.id: e};
//     //   // await orderBox.putAll(ordersMap);
//     // } catch (e, st) {
//     //   GetIt.instance<Talker>().handle(e, st);
//     //   // ordersList = orderBox.values.toList(); // Already fetched
//     // }

//     ordersList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
//     // Initial fetch for the stream if it's being listened to
//     if (_ordersStreamController.hasListener) {
//       _ordersStreamController.add(ordersList);
//     }
//     return ordersList;
//   }

//   @override
//   Stream<List<Order>> getOrderStream() {
//     // Optionally connect here if you want the stream to auto-connect on first listen
//     // _connectToWebSocket();
//     return _ordersStreamController.stream;
//   }

//   @override
//   void initiateWebSocketConnection() {
//     _connectToWebSocket();
//   }

//   void _connectToWebSocket() {
//     if (_channel != null && _channelSubscription != null) {
//       // Already connected or connecting
//       return;
//     }
//     final token = accessToken;
//     if (token == null) {
//       GetIt.I<Talker>()
//           .error('WebSocket: Access token is null, cannot connect.');
//       _ordersStreamController.addError(Exception('Access token is null'));
//       return;
//     }
//     final wsUrl =
//         Uri.parse('$apiSiteUrl/orders/active/ws'.replaceFirst('http', 'ws'));

//     // Conditional connection based on platform
//     if (kIsWeb) {
//       _channel = WebSocketChannel.connect(wsUrl);
//     } else {
//       _channel = WebSocketChannel.connect(
//         wsUrl,
//       );
//     }

//     _channelSubscription = _channel!.stream.listen(
//       (message) {
//         try {
//           final dynamic decodedMessage = jsonDecode(message);
//           List<Order> updatedOrdersList;
//           if (decodedMessage is List) {
//             updatedOrdersList = decodedMessage
//                 .map((item) => Order.fromJson(item as Map<String, dynamic>))
//                 .toList();
//           } else if (decodedMessage is Map<String, dynamic>) {
//             final newOrder = Order.fromJson(decodedMessage);
//             // Assuming the current state of orders is needed to merge a single update.
//             // This part might need adjustment based on how you want to handle single order updates.
//             // For now, let's assume the WebSocket sends the full updated list or a new single order to be added.
//             // If it's a single new order, we'd ideally merge it with the existing list from orderBox or last emitted list.
//             // However, without direct access to the BLoC's state here, we'll just emit it as a list of one.
//             // Or, better, fetch the current list and update.
//             // For simplicity, if it's a single order, we'll add it to the current box value and emit.
//             var currentOrders = orderBox.values.toList();
//             final existingOrderIndex =
//                 currentOrders.indexWhere((o) => o.id == newOrder.id);
//             if (existingOrderIndex != -1) {
//               currentOrders[existingOrderIndex] = newOrder;
//             } else {
//               currentOrders.add(newOrder);
//             }
//             updatedOrdersList = currentOrders;
//           } else {
//             GetIt.I<Talker>()
//                 .warning('WebSocket: Unknown message format: $message');
//             return;
//           }
//           updatedOrdersList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
//           orderBox
//               .putAll({for (var order in updatedOrdersList) order.id: order});
//           _ordersStreamController.add(updatedOrdersList);
//         } catch (e, st) {
//           GetIt.I<Talker>().handle(
//               e, st, 'Error processing WebSocket message in Repository');
//           _ordersStreamController.addError(e);
//         }
//       },
//       onError: (error, StackTrace stackTrace) {
//         GetIt.I<Talker>()
//             .handle(error, stackTrace, 'WebSocket error in Repository');
//         _ordersStreamController.addError(error);
//         _channel =
//             null; // Ensure channel is nullified before attempting to reconnect
//         _channelSubscription = null;
//         GetIt.I<Talker>()
//             .info('WebSocket error. Attempting to reconnect in 5 seconds...');
//         Future.delayed(const Duration(seconds: 5), () {
//           if (_ordersStreamController.hasListener) {
//             // Only reconnect if there are still listeners
//             _connectToWebSocket();
//           }
//         });
//       },
//       onDone: () {
//         GetIt.I<Talker>().info(
//             'WebSocket connection closed in Repository. Attempting to reconnect in 5 seconds...');
//         _channel =
//             null; // Ensure channel is nullified before attempting to reconnect
//         _channelSubscription = null;
//         Future.delayed(const Duration(seconds: 5), () {
//           if (_ordersStreamController.hasListener) {
//             // Only reconnect if there are still listeners
//             _connectToWebSocket();
//           }
//         });
//       },
//     );
//   }

//   @override
//   void closeOrderStream() {
//     _channelSubscription?.cancel();
//     _channel?.sink.close();
//     _channel = null;
//     _channelSubscription = null;
//     // _ordersStreamController.close(); // Do not close the main controller if it's meant to be long-lived and reused.
//     // Or, ensure it's re-initialized if closed.
//   }

//   Future<List<Order>> _fetchOrderListFromApi() async {
//     try {
//       final response = await dio.get(
//         '$apiSiteUrl/orders',
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $accessToken',
//           },
//           receiveTimeout: const Duration(seconds: 5),
//           sendTimeout: const Duration(seconds: 5),
//         ),
//       );

//       if (response.statusCode != 200) {
//         throw DioException(
//           requestOptions: response.requestOptions,
//           response: response,
//           message: 'Ошибка при загрузке данных: ${response.statusCode}',
//         );
//       }

//       final data = response.data;
//       if (data is! List) {
//         throw DioException(
//           requestOptions: response.requestOptions,
//           response: response,
//           message: 'Неожиданный формат ответа',
//         );
//       }

//       final ordersList = data.map((item) {
//         if (item is! Map<String, dynamic>) {
//           throw DioException(
//             requestOptions: response.requestOptions,
//             response: response,
//             message: 'Неверный формат данных заказа',
//           );
//         }
//         return Order.fromJson(item);
//       }).toList();

//       return ordersList;
//     } catch (e, st) {
//       GetIt.instance<Talker>().handle(e, st);
//       throw Exception('Ошибка при получении списка заказов: $e');
//     }
//   }

//   @override
//   Future<Order> getOrder(int orderId) async {
//     try {
//       final order = await _fetchOrderFromApi(orderId);
//       await orderBox.put(order.id, order);
//       return order;
//     } catch (e, st) {
//       GetIt.instance<Talker>().handle(e, st);
//       for (var key in orderBox.keys) {
//         final order = orderBox.get(key);
//         if (order != null && order.id == orderId) {
//           return order;
//         }
//       }
//       throw Exception('Ошибка при получении заказа: $e');
//     }
//   }

//   Future<Order> _fetchOrderFromApi(int orderId) async {
//     try {
//       final response = await dio.get(
//         '$apiSiteUrl/orders/$orderId',
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $accessToken',
//           },
//           receiveTimeout: const Duration(seconds: 5),
//           sendTimeout: const Duration(seconds: 5),
//         ),
//       );

//       if (response.statusCode != 200) {
//         throw DioException(
//           requestOptions: response.requestOptions,
//           response: response,
//           message: 'Ошибка при загрузке данных: ${response.statusCode}',
//         );
//       }

//       final orderData = response.data;
//       if (orderData is! Map<String, dynamic>) {
//         throw DioException(
//           requestOptions: response.requestOptions,
//           response: response,
//           message: 'Неожиданный формат ответа для заказа $orderId',
//         );
//       }

//       return Order.fromJson(orderData);
//     } catch (e) {
//       throw Exception('Ошибка при получении заказа: $e');
//     }
//   }

//   @override
//   Future<Order> createOrder(Order order) async {
//     try {
//       final response = await dio.post(
//         '$apiSiteUrl/orders/create',
//         data: order.toJson(),
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $accessToken',
//           },
//           receiveTimeout: const Duration(seconds: 5),
//           sendTimeout: const Duration(seconds: 5),
//         ),
//       );

//       if (response.statusCode != 201 && response.statusCode != 200) {
//         // 201 Created or 200 OK
//         throw DioException(
//           requestOptions: response.requestOptions,
//           response: response,
//           message: 'Ошибка при создании заказа: ${response.statusCode}',
//         );
//       }

//       final orderData = response.data;
//       if (orderData is! Map<String, dynamic>) {
//         throw DioException(
//           requestOptions: response.requestOptions,
//           response: response,
//           message: 'Неожиданный формат ответа при создании заказа',
//         );
//       }

//       final createdOrder = Order.fromJson(orderData);
//       return createdOrder;
//     } catch (e, st) {
//       GetIt.instance<Talker>().handle(e, st);
//       throw Exception('Ошибка при создании заказа: $e');
//     }
//   }
// }
