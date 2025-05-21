part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {}

class ProfileInitial extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileLoading extends ProfileState {
  @override
  List<Object?> get props => [];
}

class LoginInvalid extends ProfileState {
  LoginInvalid();

  @override
  List<Object?> get props => [];
}

class ProfileLoaded extends ProfileState {
  ProfileLoaded({
    required this.profile,
  });

  final Profile profile;

  @override
  List<Object?> get props => [profile];
}

class ProfileLoadingFailure extends ProfileState {
  ProfileLoadingFailure({
    this.exception,
  });

  final Object? exception;

  @override
  List<Object?> get props => [exception];
}