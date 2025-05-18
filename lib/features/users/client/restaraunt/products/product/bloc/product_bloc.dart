import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '/core/repositories/restaraunt/products/products.dart';

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
      final product = await productsRepository.getProduct(event.productId);
      emit(ProductLoaded(product: product));
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