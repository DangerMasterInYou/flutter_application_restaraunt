part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {}

class LoadProduct extends ProductEvent {
  LoadProduct({
    required this.productId,
    this.completer,
  });

  final int productId;
  final Completer? completer;

  @override
  List<Object?> get props => [productId, completer];
}