import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '/core/repositories/restaraunt/products/products.dart';
import '/core/repositories/restaraunt/carts/carts.dart';
import '/core/hive/models/models.dart';

import '/core/hive/models/token/token.dart';
import '/core/repositories/services/jwt_tokens/jwt_tokens.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc(this.jwtTokensRepository, this.productsRepository, this.cartsRepository) : super(MenuInitial()) {
    on<LoadMenu>(_load);
    on<AddItemCartMenu>(_addToCart);
  }

  final AbstractJWTTokensRepository jwtTokensRepository;
  final AbstractProductsRepository productsRepository;
  final AbstractCartsRepository cartsRepository;

  Future<void> _load(
    LoadMenu event,
    Emitter<MenuState> emit,
  ) async {
    try {
      emit(MenuLoading());
      
      bool isTokenValid = false;
      try {
        isTokenValid = await _withTimeout(
          jwtTokensRepository.getCheckJWTTokens(),
          const Duration(seconds: 5),
          'Token validation timeout'
        );
      } catch (e, st) {
        GetIt.I<Talker>().handle(e, st);
        isTokenValid = false;
      }
      
      // if (!isTokenValid) {
      //   emit(LoginInvalid());
      //   return;
      // }
      
      List<Product> productsList = [];
      try {
        productsList = await _withTimeout(
          productsRepository.getProductsList(),
          const Duration(seconds: 5),
          'Products list fetch timeout'
        );
      } catch (e, st) {
        GetIt.I<Talker>().handle(e, st);
        throw Exception('Failed to load menu items: $e');
      }
      
      emit(MenuLoaded(productsList: productsList));
    } catch (e, st) {
      emit(MenuLoadingFailure(exception: e));
      GetIt.I<Talker>().handle(e, st);
    } finally {
      event.completer?.complete();
    }
  }
  
  Future<T> _withTimeout<T>(Future<T> future, Duration timeout, String message) {
    return future.timeout(
      timeout,
      onTimeout: () => throw TimeoutException(message, timeout),
    );
  }

  Future<void> _addToCart(
    AddItemCartMenu event,
    Emitter<MenuState> emit,
  ) async {
    try {
      await cartsRepository.postAddItemCart(event.cartItem);
      emit(MenuLoading());
      await _load(LoadMenu(), emit);
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      await _load(LoadMenu(), emit);
    }
  }
  
  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}