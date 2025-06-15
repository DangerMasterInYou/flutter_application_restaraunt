import 'package:flutter/material.dart';
import 'package:flutter_application_restaraunt/core/router/router.dart';
import 'package:flutter_application_restaraunt/core/theme/theme.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class FlutterApplicationRestaraunt extends StatefulWidget {
  const FlutterApplicationRestaraunt({super.key});

  @override
  State<FlutterApplicationRestaraunt> createState() => _AppState();
}

class _AppState extends State<FlutterApplicationRestaraunt> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'DonerKebab',
      theme: darkTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru', 'RU'),
        Locale('en', ''),
      ],
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            viewInsets: MediaQuery.of(context).viewInsets,
          ),
          child: child!,
        );
      },
      routerConfig: _appRouter.config(
        navigatorObservers: () => [TalkerRouteObserver(GetIt.I<Talker>())],
      ),
    );
  }
}
