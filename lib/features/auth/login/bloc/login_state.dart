part of 'login_bloc.dart';

abstract class LoginState extends Equatable {}

class LoginInitial extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginLoading extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginLoaded extends LoginState {
  LoginLoaded({
    required this.token,
  });
  
  final Token token;

  @override
  List<Object?> get props => [token];
}

class LoginFailure extends LoginState {
  LoginFailure({
    this.exception,
  });

  final Object? exception;

  @override
  List<Object?> get props => [exception];
}