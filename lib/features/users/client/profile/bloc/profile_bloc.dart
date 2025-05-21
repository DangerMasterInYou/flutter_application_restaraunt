import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '/core/repositories/profile/profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this.profilesRepository) : super(ProfileInitial()) {
    on<LoadProfile>(_load);
    on<ResetPassword>(_resetPassword);
  }

  final AbstractProfilesRepository profilesRepository;

  Future<void> _load(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      if (state is! ProfileLoaded) {
        emit(ProfileLoading());
      }
      final profile = await profilesRepository.getProfilesList();
      emit(ProfileLoaded(profile: profile));
    } catch (e, st) {
      emit(ProfileLoadingFailure(exception: e));
      GetIt.I<Talker>().handle(e, st);
    } finally {
      event.completer?.complete();
    }
  }

  Future<void> _resetPassword(
    ResetPassword event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      // await profilesRepository.postResetPassword(event.profile);
      add(LoadProfile());
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      add(LoadProfile());
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}