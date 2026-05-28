import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '/core/repositories/restaraunt/menu/menu.dart';
import '/core/repositories/users/client/restaraunt/carts/carts.dart';
import '/core/hive/models/menu/menu.dart'; // For Menu model
// import '/core/hive/models/cart_item/cart_item.dart'; // For CartItem model if used in AddItemCartMenu event

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc(this.menuRepository) : super(MenuInitial()) {
    on<LoadMenu>(_load);
    // on<AddItemCartMenu>(_addToCart);
  }

  final AbstractMenuRepository menuRepository;
  // final AbstractCartsRepository cartsRepository;

  Future<void> _load(
    LoadMenu event,
    Emitter<MenuState> emit,
  ) async {
    try {
      emit(MenuLoading());

      // bool isTokenValid = false;
      // try {
      //   isTokenValid = await _withTimeout(
      //     jwtTokensRepository.getCheckJWTTokens(),
      //     const Duration(seconds: 5),
      //     'Token validation timeout'
      //   );
      // } catch (e, st) {
      //   GetIt.I<Talker>().handle(e, st);
      List<Menu> menuList = [];
      try {
        menuList = await _withTimeout(
          menuRepository.getMenuList(),
          const Duration(
              seconds: 10), // Increased timeout for potentially larger data
          'Menu list fetch timeout',
        );
        if (menuList.isEmpty) {
          throw Exception('Menu not found (404)');
        }
      } catch (e, st) {
        GetIt.I<Talker>().handle(e, st);
        // Re-throw to be caught by the outer try-catch, which emits MenuLoadingFailure
        throw Exception('Failed to load menu items: $e');
      }

      emit(MenuLoaded(menuList: menuList));
    } catch (e, st) {
      emit(MenuLoadingFailure(exception: e));
      GetIt.I<Talker>().handle(e, st);
    } finally {
      event.completer?.complete();
    }
  }

  Future<T> _withTimeout<T>(
      Future<T> future, Duration timeout, String message) {
    return future.timeout(
      timeout,
      onTimeout: () => throw TimeoutException(message, timeout),
    );
  }

  // Future<void> _addToCart(
  //   AddItemCartMenu event,
  //   Emitter<MenuState> emit,
  // ) async {
  //   try {
  //     // await cartsRepository.postAddItemCart(event.cartItem);
  //     emit(MenuLoading());
  //     await _load(LoadMenu(), emit);
  //   } catch (e, st) {
  //     GetIt.I<Talker>().handle(e, st);
  //     await _load(LoadMenu(), emit);
  //   }
  // }

  // @override
  // void onError(Object error, StackTrace stackTrace) {
  //   super.onError(error, stackTrace);
  //   GetIt.I<Talker>().handle(error, stackTrace);
  // }
}
