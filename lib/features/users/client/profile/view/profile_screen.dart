import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '/core/repositories/users/client/profile/profile.dart';
import '/core/repositories/auth/login/login.dart';
import '/core/router/router.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/widgets.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileBloc _profileBloc;
  final _refreshCompleter = Completer<void>();

  @override
  void initState() {
    super.initState();
    _profileBloc = ProfileBloc(
      GetIt.I<AbstractProfilesRepository>(),
      GetIt.I<AbstractLoginRepository>(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tokenBox = GetIt.I<Box<Token>>();
      if (tokenBox.isEmpty) {
        // Используем AutoRouter для навигации
        AutoRouter.of(context).replace(const LoginRoute());
      } else {
        _profileBloc.add(LoadProfile(completer: _refreshCompleter));
      }
    });
  }

  @override
  void dispose() {
    _profileBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: const Text('Профиль', style: TextStyle(fontSize: 40))),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _profileBloc.add(LogoutProfile());
            },
          ),
        ],
      ),
      body: BlocProvider.value(
        value: _profileBloc,
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileInitial || state is ProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ProfileLoaded) {
              return RefreshIndicator(
                onRefresh: () {
                  _profileBloc.add(LoadProfile(completer: _refreshCompleter));
                  return _refreshCompleter.future;
                },
                child: ProfileContent(profile: state.profile),
              );
            } else if (state is ProfileLoadingFailure) {
              return Center(
                child: Text('Ошибка загрузки: ${state.exception}'),
              );
            } else if (state is LoginInvalid) {
              // Используем WidgetsBinding.instance.addPostFrameCallback для безопасного вызова AutoRouter
              // во время фазы build, если навигация не произошла в initState.
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) { // Убедимся, что виджет все еще в дереве
                  AutoRouter.of(context).replace(const LoginRoute());
                }
              });
              return const Center(
                child: CircularProgressIndicator(), // Показываем индикатор во время перенаправления
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}