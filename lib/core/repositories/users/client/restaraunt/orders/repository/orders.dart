import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '/core/repositories/services/jwt_tokens/jwt_tokens.dart';
import '../dto/dto.dart';
import 'abstract_orders.dart';

class OrdersRepository implements AbstractOrdersRepository {
  OrdersRepository({required this.dio, required this.apiSiteUrl});

  final Dio dio;
  final String apiSiteUrl;

  static String? get _token =>
      GetIt.I<AbstractJWTTokensRepository>().getAccessToken();

  Options get _authOptions =>
      Options(headers: {'Authorization': 'Bearer $_token'});

  @override
  Future<List<OrderResponseDTO>> getOrdersList() async {
    try {
      final response = await dio.get(
        '$apiSiteUrl/orders',
        options: _authOptions,
      );
      final data = response.data;
      if (data is! List) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Неожиданный формат списка заказов',
        );
      }
      return data
          .map((item) =>
              OrderResponseDTO.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      rethrow;
    }
  }

  @override
  Future<OrderResponseDTO> getOrder(int orderId) async {
    try {
      final response = await dio.get(
        '$apiSiteUrl/orders/$orderId',
        options: _authOptions,
      );
      return OrderResponseDTO.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      rethrow;
    }
  }

  @override
  Future<OrderResponseDTO> createOrder(OrderCreateRequestDTO request) async {
    try {
      final response = await dio.post(
        '$apiSiteUrl/orders/create',
        data: request.toJson(),
        options: _authOptions,
      );
      return OrderResponseDTO.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      rethrow;
    }
  }

  @override
  Future<OrderResponseDTO> updateOrderStatus(
    int orderId,
    OrderStatusUpdateRequestDTO request,
  ) async {
    try {
      final response = await dio.patch(
        '$apiSiteUrl/orders/$orderId/status',
        data: request.toJson(),
        options: _authOptions,
      );
      return OrderResponseDTO.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      rethrow;
    }
  }
}
