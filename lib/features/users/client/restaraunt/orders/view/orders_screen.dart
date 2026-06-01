import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '/core/repositories/users/client/restaraunt/orders/orders.dart';
import '/core/router/router.dart';
import '../bloc/orders_bloc.dart';

enum OrdersFilter { active, archived }

@RoutePage()
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late final OrdersBloc _ordersBloc;
  OrdersFilter _filter = OrdersFilter.active;

  @override
  void initState() {
    super.initState();
    _ordersBloc = OrdersBloc(GetIt.I<AbstractOrdersRepository>())
      ..add(const LoadOrders());
  }

  @override
  void dispose() {
    _ordersBloc.close();
    super.dispose();
  }

  List<OrderResponseDTO> _filtered(List<OrderResponseDTO> orders) {
    return orders.where((order) {
      return _filter == OrdersFilter.active ? order.isActive : order.isArchived;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = _formatDateTime;

    return BlocProvider.value(
      value: _ordersBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Мои заказы'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: SegmentedButton<OrdersFilter>(
                segments: const [
                  ButtonSegment(
                    value: OrdersFilter.active,
                    label: Text('Активные'),
                    icon: Icon(Icons.pending_actions),
                  ),
                  ButtonSegment(
                    value: OrdersFilter.archived,
                    label: Text('Архив'),
                    icon: Icon(Icons.archive_outlined),
                  ),
                ],
                selected: {_filter},
                onSelectionChanged: (selection) {
                  setState(() => _filter = selection.first);
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<OrdersBloc, OrdersState>(
                builder: (context, state) {
                  if (state is OrdersLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is OrdersLoadingFailure) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Ошибка загрузки: ${state.exception}',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton(
                            onPressed: () =>
                                _ordersBloc.add(const LoadOrders()),
                            child: const Text('Повторить'),
                          ),
                        ],
                      ),
                    );
                  }

                  final orders = switch (state) {
                    OrdersLoaded(:final ordersList) => ordersList,
                    OrdersDetailLoading(:final ordersList) => ordersList,
                    OrdersDetailFailure(:final ordersList) => ordersList,
                    _ => const <OrderResponseDTO>[],
                  };

                  final filtered = _filtered(orders);

                  if (filtered.isEmpty) {
                    return Center(
                      child: Text(
                        _filter == OrdersFilter.active
                            ? 'Нет активных заказов'
                            : 'Архив пуст',
                        style: theme.textTheme.titleMedium,
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final order = filtered[index];
                      return Card(
                        child: ListTile(
                          title: Text(order.displayNumber),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Статус: ${order.status}'),
                              Text(
                                dateFormat(order.createdAt.toLocal()),
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${order.totalPrice} ₽',
                                style: theme.textTheme.titleMedium,
                              ),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                          onTap: () {
                            context.router.push(
                              OrderDetailRoute(orderId: order.id),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDateTime(DateTime date) {
  final d = date.day.toString().padLeft(2, '0');
  final m = date.month.toString().padLeft(2, '0');
  final h = date.hour.toString().padLeft(2, '0');
  final min = date.minute.toString().padLeft(2, '0');
  return '$d.$m.${date.year} $h:$min';
}
