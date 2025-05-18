part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {}

class LoadLogin extends LoginEvent {
  LoadLogin({
    this.completer,
  });
  
  final Completer? completer;

  @override
  List<Object?> get props => [completer];
}

class SubmitLogin extends LoginEvent {
  SubmitLogin({
    required this.email,
    required this.password,
    this.completer,
  });
  
  final String email;
  final String password;
  final Completer? completer;

  @override
  List<Object?> get props => [email, password, completer];
}