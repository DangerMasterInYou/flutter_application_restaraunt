import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '/core/repositories/restaraunt/carts/carts.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(this.cartsRepository) : super(CartInitial()) {
    on<LoadCartList>(_load);
    on<AddToCart>(_addToCart);
    on<SubtractFromCart>(_subtractFromCart);
    on<DeleteItemFromCart>(_deleteFromCart);
  }

  final AbstractCartsRepository cartsRepository;

  Future<void> _load(
    LoadCartList event,
    Emitter<CartState> emit,
  ) async {
    try {
      if (state is! CartLoaded) {
        emit(CartLoading());
      }
      final cartList = await cartsRepository.getCartsList();
      emit(CartLoaded(cartList: cartList));
    } catch (e, st) {
      emit(CartLoadingFailure(exception: e));
      GetIt.I<Talker>().handle(e, st);
    } finally {
      event.completer?.complete();
    }
  }

  Future<void> _deleteFromCart(
    DeleteItemFromCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      await cartsRepository.postDeleteItemCart(event.cart);
      add(LoadCartList());
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      add(LoadCartList());
    }
  }

  Future<void> _addToCart(
    AddToCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      await cartsRepository.postAddItemCart(event.cart);
      add(LoadCartList());
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      add(LoadCartList());
    }
  }

  Future<void> _subtractFromCart(
    SubtractFromCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      await cartsRepository.postSubtractItemCart(event.cart);
      add(LoadCartList());
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      add(LoadCartList());
    }
  }
  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}