// profile_event.dart

part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class LoadProfile extends ProfileEvent {
  LoadProfile({
    this.completer,
  });

  final Completer? completer;

  @override
  List<Object?> get props => [completer];
}

// Событие теперь принимает ProfilePatchDTO
class UpdateProfile extends ProfileEvent {
  const UpdateProfile({
    required this.patchDto,
  });

  final ProfilePatchDTO patchDto;

  @override
  List<Object?> get props => [patchDto];
}

// Событие ResetPassword удалено
class DeleteProfile extends ProfileEvent {
  const DeleteProfile();

  @override
  List<Object?> get props => [];
}