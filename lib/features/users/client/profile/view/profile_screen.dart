// profile_screen.dart

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '/core/router/router.dart';
import '/core/repositories/users/client/profile/profile.dart';
import '/core/repositories/services/jwt_tokens/abstract_jwt_tokens_repository.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/widgets.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileBloc _profileBloc =
      ProfileBloc(GetIt.I<AbstractProfileRepository>());

  @override
  void initState() {
    super.initState();
    _profileBloc.add(LoadProfile());
  }

  @override
  void dispose() {
    _profileBloc.close();
    super.dispose();
  }

  Future<void> _onRefresh() {
    final completer = Completer<void>();
    _profileBloc.add(LoadProfile(completer: completer));
    return completer.future;
  }

  Future<void> _logout(BuildContext context, {bool force = false}) async {
    bool? confirmed = force;

    if (!force) {
      confirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Выход из аккаунта'),
            content: const Text('Вы уверены, что хотите выйти?',
                style: TextStyle(color: Colors.black)),
            actions: <Widget>[
              TextButton(
                child:
                    const Text('Отмена', style: TextStyle(color: Colors.black)),
                onPressed: () => Navigator.of(dialogContext).pop(false),
              ),
              TextButton(
                child:
                    const Text('Выйти', style: TextStyle(color: Colors.black)),
                onPressed: () => Navigator.of(dialogContext).pop(true),
              ),
            ],
          );
        },
      );
    }

    if (confirmed == true) {
      await GetIt.I<AbstractJWTTokensRepository>().clearTokens();

      if (mounted) {
        context.router.replaceAll([const LoginRoute()]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          tooltip: 'Меню',
          onPressed: () {
            context.router.push(const MenuRoute());
          },
        ),
        title: const Text('Профиль', style: TextStyle(fontSize: 24)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Выйти',
            onPressed: () => _logout(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocProvider.value(
        value: _profileBloc,
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            // Успешное обновление
            if (state is ProfileLoaded &&
                _profileBloc.state is ProfileLoading) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Профиль успешно обновлен!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
            // Ошибка обновления
            else if (state is ProfileUpdateFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Ошибка обновления профиля: ${state.exception}'),
                  backgroundColor: Colors.red,
                ),
              );
              _profileBloc.emit(ProfileLoaded(profile: state.lastProfile));
            }
            // Успешное удаление
            else if (state is ProfileDeleteSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Профиль успешно удален.'),
                  backgroundColor: Colors.green,
                ),
              );
              _logout(context, force: true);
            }
            // Ошибка удаления
            else if (state is ProfileDeleteFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Ошибка удаления профиля: ${state.exception}'),
                  backgroundColor: Colors.red,
                ),
              );
              _profileBloc.emit(ProfileLoaded(profile: state.lastProfile));
            }
          },
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileInitial ||
                  state is ProfileLoading ||
                  state is ProfileDeleteInProgress) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ProfileLoaded) {
                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  color: Colors.white,
                  backgroundColor: Colors.grey[900],
                  child: ProfileContent(
                    profile: state.profile,
                    profileBloc: _profileBloc,
                  ),
                );
              }

              if (state is ProfileLoadingFailure) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.cloud_off_rounded,
                          color: Colors.grey,
                          size: 80,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Не удалось загрузить профиль',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Пожалуйста, проверьте ваше интернет-соединение и попробуйте снова.',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[400]),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: const Text('Попробовать снова'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                          onPressed: () => _profileBloc.add(LoadProfile()),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is ProfileUpdateFailure ||
                  state is ProfileDeleteFailure) {
                final profile = (state is ProfileUpdateFailure)
                    ? state.lastProfile
                    : (state as ProfileDeleteFailure).lastProfile;
                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: Builder(
                    builder: (context) => ProfileContent(
                      profile: profile,
                      profileBloc: _profileBloc,
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
