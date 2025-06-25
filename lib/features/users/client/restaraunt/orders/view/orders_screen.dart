// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:auto_route/auto_route.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get_it/get_it.dart';

// import '/core/repositories/users/client/restaraunt/orders/orders.dart';
// import '../bloc/orders_bloc.dart';

// @RoutePage()
// class OrdersScreen extends StatefulWidget {
//   const OrdersScreen({super.key});

//   @override
//   State<OrdersScreen> createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen> {
//   late final OrdersBloc _ordersBloc;
//   Status? _selectedStatus;

//   @override
//   void initState() {
//     super.initState();
//     _ordersBloc = OrdersBloc(
//       GetIt.I<AbstractOrdersRepository>(),
//     );
//     _ordersBloc.add(LoadOrders());
//   }

//   @override
//   void dispose() {
//     _ordersBloc.close();
//     super.dispose();
//   }

//   List<Order> _getFilteredOrders(List<Order> orders) {
//     if (_selectedStatus == null) {
//       return orders;
//     }
//     return orders.where((order) => order.status == _selectedStatus).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return BlocProvider.value(
//       value: _ordersBloc,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Мои заказы'),
//           backgroundColor: const Color.fromARGB(255, 30, 30, 30),
//         ),
//         body: Column(
//           children: [
//             Container(
//               color: const Color.fromARGB(255, 30, 30, 30),
//               padding: const EdgeInsets.all(16),
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: [
//                     FilterChip(
//                       label: const Text('Все'),
//                       selected: _selectedStatus == null,
//                       onSelected: (selected) {
//                         setState(() {
//                           _selectedStatus = null;
//                         });
//                       },
//                       backgroundColor: Colors.grey[800],
//                       selectedColor: Colors.white,
//                       checkmarkColor: Colors.black,
//                       labelStyle: TextStyle(
//                         color: _selectedStatus == null ? Colors.black : Colors.white,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     ...Status.values.map((status) {
//                       return Padding(
//                         padding: const EdgeInsets.only(right: 8),
//                         child: FilterChip(
//                           label: Text(status.russianUpperCase),
//                           selected: _selectedStatus == status,
//                           onSelected: (selected) {
//                             setState(() {
//                               _selectedStatus = selected ? status : null;
//                             });
//                           },
//                           backgroundColor: Colors.grey[800],
//                           selectedColor: Colors.white,
//                           checkmarkColor: Colors.black,
//                           labelStyle: TextStyle(
//                             color: _selectedStatus == status ? Colors.black : Colors.white,
//                           ),
//                         ),
//                       );
//                     }),
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//               child: BlocBuilder<OrdersBloc, OrdersState>(
//                 builder: (context, state) {
//                   if (state is OrdersLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   if (state is OrdersLoadingFailure) {
//                     return Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'Ошибка при загрузке заказов: ${state.exception.toString()}',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(color: theme.colorScheme.error),
//                           ),
//                           const SizedBox(height: 16),
//                           OutlinedButton(
//                             onPressed: () {
//                               _ordersBloc.add(LoadOrders());
//                             },
//                             child: const Text('Попробовать снова'),
//                           ),
//                         ],
//                       ),
//                     );
//                   }

//                   if (state is OrdersWebSocketFailure) {
//                     String errorMessage = 'Ошибка WebSocket: ${state.exception?.toString() ?? 'Неизвестная ошибка'}';
//                     final previousState = _ordersBloc.state;
//                     if (previousState is OrdersLoaded) {
//                       WidgetsBinding.instance.addPostFrameCallback((_) {
//                         if (mounted && context.mounted) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(errorMessage, style: const TextStyle(color: Colors.white)),
//                               backgroundColor: Colors.redAccent,
//                               duration: const Duration(seconds: 5),
//                             ),
//                           );
//                         }
//                       });
//                       final filteredOrders = _getFilteredOrders(previousState.ordersList);
//                       if (filteredOrders.isEmpty) {
//                         return Center(
//                           child: Text(
//                             _selectedStatus == null
//                                 ? 'У вас пока нет заказов'
//                                 : 'Нет заказов со статусом ${_selectedStatus!.russianLowerCase}',
//                             style: theme.textTheme.titleMedium,
//                           ),
//                         );
//                       }
//                       return _buildOrdersList(context, theme, filteredOrders);
//                     } else {
//                       return Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               errorMessage,
//                               textAlign: TextAlign.center,
//                               style: TextStyle(color: theme.colorScheme.error),
//                             ),
//                             const SizedBox(height: 16),
//                             OutlinedButton(
//                               onPressed: () {
//                                 _ordersBloc.add(LoadOrders());
//                               },
//                               child: const Text('Переподключиться'),
//                             ),
//                           ],
//                         ),
//                       );
//                     }
//                   }

//                   if (state is OrdersLoaded) {
//                     final filteredOrders = _getFilteredOrders(state.ordersList);

//                     if (filteredOrders.isEmpty) {
//                       return Center(
//                         child: Text(
//                           _selectedStatus == null
//                               ? 'У вас пока нет заказов'
//                               : 'Нет заказов со статусом ${_selectedStatus!.russianLowerCase}',
//                           style: theme.textTheme.titleMedium,
//                         ),
//                       );
//                     }
//                     return _buildOrdersList(context, theme, filteredOrders);
//                   }
//                   return const Center(child: Text('Нет данных для отображения.'));
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOrdersList(BuildContext context, ThemeData theme, List<Order> orders) {
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: orders.length,
//       itemBuilder: (context, index) {
//         final order = orders[index];
//         return Card(
//           margin: const EdgeInsets.only(bottom: 16),
//           color: const Color.fromARGB(255, 30, 30, 30),
//           child: ListTile(
//             title: Text(
//               'Заказ #${order.id}',
//               style: const TextStyle(color: Colors.white),
//             ),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Статус: ${order.status.russianUpperCase}',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   'Создан: ${order.createdAt.toString()}',
//                   style: const TextStyle(color: Colors.grey),
//                 ),
//               ],
//             ),
//             trailing: Chip(
//               label: Text(
//                 order.status.russianUpperCase,
//                 style: const TextStyle(color: Colors.black),
//               ),
//               backgroundColor: Colors.white,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
