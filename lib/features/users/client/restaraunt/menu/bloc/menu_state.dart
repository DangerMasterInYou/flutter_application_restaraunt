part of 'menu_bloc.dart';

abstract class MenuState extends Equatable {}

class MenuInitial extends MenuState {
  @override
  List<Object?> get props => [];
}

class MenuLoading extends MenuState {
  @override
  List<Object?> get props => [];
}

// class LoginInvalid extends MenuState {
//   LoginInvalid();

//   @override
//   List<Object?> get props => [];
// }

class MenuLoaded extends MenuState {
  MenuLoaded({
    required this.productsList,
  });

  final List<Product> productsList;

  @override
  List<Object?> get props => [productsList];
}

class MenuLoadingFailure extends MenuState {
  MenuLoadingFailure({
    this.exception,
  });

  final Object? exception;

  @override
  List<Object?> get props => [exception];
}