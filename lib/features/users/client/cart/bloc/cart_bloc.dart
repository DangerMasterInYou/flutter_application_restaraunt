import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '/core/repositories/users/client/restaraunt/carts/carts.dart';


part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(this.cartRepository) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddItemToCart>(_onAddItem);
    on<UpdateItemQuantity>(_onUpdateQuantity);
    on<RemoveItemFromCart>(_onRemoveItem);
  }

  final AbstractCartRepository cartRepository;

  void _handleSuccess(CartResponseDTO response, Emitter<CartState> emit) {
    emit(CartLoading());
    emit(CartLoaded(cartResponse: response));
  }
  
  void _handleError(Object e, StackTrace st, Emitter<CartState> emit) {
      emit(CartLoadingFailure(exception: e));
      GetIt.I<Talker>().handle(e, st);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    try {
      emit(CartLoading());
      final cartResponse = await cartRepository.getCart();
      emit(CartLoaded(cartResponse: cartResponse));
    } catch (e, st) {
      _handleError(e, st, emit);
    }
  }

  Future<void> _onAddItem(AddItemToCart event, Emitter<CartState> emit) async {
    try {
      final newCartState = await cartRepository.addItemToCart(event.item);
      _handleSuccess(newCartState, emit);
    } catch (e, st) {
      _handleError(e, st, emit);
    }
  }

  Future<void> _onUpdateQuantity(UpdateItemQuantity event, Emitter<CartState> emit) async {
    try {
      final newCartState = await cartRepository.updateItemQuantity(event.cartItemId, event.newQuantity);
      _handleSuccess(newCartState, emit);
    } catch (e, st) {
      _handleError(e, st, emit);
    }
  }

  Future<void> _onRemoveItem(RemoveItemFromCart event, Emitter<CartState> emit) async {
    try {
      final newCartState = await cartRepository.deleteItemFromCart(event.cartItemId);
      _handleSuccess(newCartState, emit);
    } catch (e, st) {
      _handleError(e, st, emit);
    }
  }
}