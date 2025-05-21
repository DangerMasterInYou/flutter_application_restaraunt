part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {}

class LoadProfile extends ProfileEvent {
  LoadProfile({
    this.completer,
  });

  final Completer? completer;

  @override
  List<Object?> get props => [completer];
}

class ResetPassword extends ProfileEvent {
  ResetPassword({
    required this.profile,
  });

  final Profile profile;

  @override
  List<Object?> get props => [profile];
}