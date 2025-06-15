part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {}

class LoadProduct extends ProductEvent {
  LoadProduct({
    required this.productName,
    this.completer,
  });

  final String productName;
  final Completer? completer;

  @override
  List<Object?> get props => [productName, completer];
}