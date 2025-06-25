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
    required this.menuList,
  });

  final List<Menu> menuList;

  @override
  List<Object?> get props => [menuList];
}

class MenuLoadingFailure extends MenuState {
  MenuLoadingFailure({
    this.exception,
  });

  final Object? exception;

  @override
  List<Object?> get props => [exception];
}
