import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

// import '/core/hive/models/profile/profile.dart'; 
import '/core/repositories/users/client/profile/profile.dart';
import '/core/repositories/auth/login/login.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this.profilesRepository, this.loginRepository) : super(ProfileInitial()) {
    on<LoadProfile>(_load);
    on<ResetPassword>(_resetPassword);
    on<UpdateProfile>(_updateProfile);
    on<LogoutProfile>(_logout);
  }

  final AbstractProfilesRepository profilesRepository;
  final AbstractLoginRepository loginRepository;

  Future<void> _load(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      if (state is! ProfileLoaded) {
        emit(ProfileLoading());
      }
      // Проверка токена перед загрузкой профиля
      final tokenBox = GetIt.I<Box<Token>>();
      if (tokenBox.isEmpty) {
        emit(LoginInvalid());
        return;
      }
      final profile = await profilesRepository.getProfile();
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
      // add(LoadProfile()); 
      GetIt.I<Talker>().log('Password reset requested for ${event.profile.username}');
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      // add(LoadProfile());
    }
  }

  Future<void> _updateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      // await profilesRepository.updateProfile(event.profile);
      await Future.delayed(const Duration(seconds: 1)); 
      emit(ProfileLoaded(profile: event.profile)); 
      GetIt.I<Talker>().log('Profile updated: ${event.profile.username}');
    } catch (e, st) {
      emit(ProfileLoadingFailure(exception: e));
      GetIt.I<Talker>().handle(e, st);
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }

  Future<void> _logout(
    LogoutProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading()); // Опционально, для индикации процесса выхода
      await loginRepository.logout();
      emit(LoginInvalid()); // Состояние для перенаправления на логин
    } catch (e, st) {
      emit(ProfileLoadingFailure(exception: e)); // Обработка ошибок при выходе
      GetIt.I<Talker>().handle(e, st);
    }
  }
}