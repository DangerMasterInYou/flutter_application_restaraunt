import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '/core/repositories/auth/login/login.dart';
import '/core/repositories/services/services.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this.loginRepository) : super(LoginInitial()) {
    on<SubmitLogin>(_submitLogin);
  }

  final AbstractLoginRepository loginRepository;

  Future<void> _submitLogin(
    SubmitLogin event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(LoginLoading());
      
      final token = await loginRepository.postLogin(
        event.email, 
        event.password
      );
      
      if (token != null ) {
        emit(LoginLoaded(token: token));
      } else {
        emit(LoginFailure(exception: Exception('Получен невалидный ответ: $token')));
      }
    } catch (e, st) {
      emit(LoginFailure(exception: e));
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