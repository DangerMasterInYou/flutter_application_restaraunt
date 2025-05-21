import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '/core/repositories/profile/profile.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/widgets.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileBloc _profileBloc = ProfileBloc(GetIt.I<AbstractProfilesRepository>());
  final _refreshCompleter = Completer<void>();

  @override
  void initState() {
    super.initState();
    _profileBloc.add(LoadProfile(completer: _refreshCompleter));
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
        title: const Text('Профиль'),
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
              return const Center(
                child: Text('Необходимо авторизоваться'),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}