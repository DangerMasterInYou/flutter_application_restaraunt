import '../orders.dart';

abstract class AbstractOrdersRepository {
  Future<List<Order>> getOrdersList();
  Future<Order> getOrder(int orderId);
  Future<Order> createOrder(Order order);
  Stream<List<Order>> getOrdersStream();
  void closeOrdersStream();
  void initiateWebSocketConnection();
}