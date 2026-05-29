import '../dto/dto.dart';

abstract class AbstractOrdersRepository {
  Future<List<OrderResponseDTO>> getOrdersList();

  Future<OrderResponseDTO> getOrder(int orderId);

  Future<OrderResponseDTO> createOrder(OrderCreateRequestDTO request);

  Future<OrderResponseDTO> updateOrderStatus(
    int orderId,
    OrderStatusUpdateRequestDTO request,
  );
}
