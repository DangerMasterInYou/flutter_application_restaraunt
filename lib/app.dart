import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_restaraunt/core/router/router.dart';
import 'package:flutter_application_restaraunt/core/theme/theme.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_application_restaraunt/features/users/admin/view/admin_panel_screen.dart';
import 'package:flutter_application_restaraunt/features/users/client/restaraunt/menu/view/menu_screen.dart';
import 'core/repositories/services/jwt_tokens/abstract_jwt_tokens_repository.dart';

class FlutterApplicationRestaraunt extends StatelessWidget {
  const FlutterApplicationRestaraunt({super.key});

  @override
  Widget build(BuildContext context) {
    final _appRouter = AppRouter();
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _appRouter.config(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru', 'RU'),
        Locale('en', 'US'),
      ],
    );
  }
}
