import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '/core/repositories/users/client/restaraunt/products/products.dart';
import '/core/hive/models/product_full/product/product.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc(this.productsRepository) : super(ProductInitial()) {
    on<LoadProduct>(_load);
  }

  final AbstractProductsRepository productsRepository;

  Future<void> _load(
    LoadProduct event,
    Emitter<ProductState> emit,
  ) async {
    try {
      if (state is! ProductLoaded) {
        emit(ProductLoading());
      }
      final products = await productsRepository.getProductsList();
      final product = products.firstWhere((p) => p.name == event.productName,
          orElse: () => throw Exception('Product not found'));
      final productFull = await productsRepository.getFullProduct(product.id);
      if (productFull != null) {
        emit(ProductLoaded(product: productFull));
      } else {
        emit(ProductLoadingFailure(exception: 'Product not found'));
      }
    } catch (e, st) {
      emit(ProductLoadingFailure(exception: e));
      GetIt.I<Talker>().handle(e, st);
    } finally {
      event.completer?.complete();
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}
