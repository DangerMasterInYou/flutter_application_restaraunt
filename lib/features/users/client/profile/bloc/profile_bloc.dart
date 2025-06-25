// profile_bloc.dart

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '/core/repositories/users/client/profile/profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  // Исправлено имя репозитория для соответствия
  ProfileBloc(this.profileRepository) : super(ProfileInitial()) {
    on<LoadProfile>(_load);
    on<UpdateProfile>(_updateProfile);
    on<DeleteProfile>(_delete); 
  }

  // Тип изменен на AbstractProfileRepository
  final AbstractProfileRepository profileRepository;

  Future<void> _load(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      // Чтобы избежать мигания, показываем загрузку только если данные еще не загружены
      if (state is! ProfileLoaded) {
        emit(ProfileLoading());
      }
      // Используем метод из репозитория
      final profile = await profileRepository.getProfile();
      emit(ProfileLoaded(profile: profile));
    } catch (e, st) {
      emit(ProfileLoadingFailure(exception: e));
      GetIt.I<Talker>().handle(e, st);
    } finally {
      // Завершаем Completer для RefreshIndicator
      event.completer?.complete();
    }
  }

  Future<void> _updateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      // Сохраняем текущий профиль, чтобы можно было к нему вернуться в случае ошибки
      final lastState = state;
      // Переходим в состояние загрузки (обновления)
      emit(ProfileLoading());

      // Вызываем метод patchProfile с DTO, содержащим только изменения
      await profileRepository.patchProfile(event.patchDto);

      // После успешного обновления запрашиваем свежие данные с сервера
      add(LoadProfile());
      GetIt.I<Talker>().log('Profile update request sent.');

    } catch (e, st) {
      // В случае ошибки возвращаем предыдущее состояние и показываем ошибку
      if (state is ProfileLoaded) {
         emit(ProfileUpdateFailure(exception: e, lastProfile: (state as ProfileLoaded).profile));
      } else {
         emit(ProfileLoadingFailure(exception: e));
      }
      GetIt.I<Talker>().handle(e, st);
    }
  }
  
  Future<void> _delete(
    DeleteProfile event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      try {
        emit(ProfileDeleteInProgress());
        await profileRepository.deleteProfile();
        emit(ProfileDeleteSuccess());
      } catch (e) {
        // В случае ошибки возвращаем пользователя на экран профиля
        emit(ProfileDeleteFailure(exception: e, lastProfile: currentState.profile));
      }
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    GetIt.I<Talker>().handle(error, stackTrace);
  }
}