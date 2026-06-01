import 'dart:async';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter_application_restaraunt/api_config.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';

import 'core/core.dart';
import 'app.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  final apiSiteUrl = dotenv.env['API_SITE_URL'] ?? 'http://127.0.0.1:8000';
  ApiConfig.apiSiteUrl = dotenv.env['API_SITE_URL'] ?? 'http://127.0.0.1:8000';
  // final apiSiteUrl = 'http://127.0.0.1:8000';

  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.ensureVisualUpdate();

    if (!kIsWeb) {
      SystemChannels.textInput.invokeMethod('TextInput.setImeHidden', true);
    } else if (kIsWeb) {
      setUrlStrategy(PathUrlStrategy());
    }

    final talker = TalkerFlutter.init();
    GetIt.I.registerSingleton(talker);
    GetIt.I<Talker>().debug('Talker started...');

    Hive.registerAdapter(TokenAdapter());
    Hive.registerAdapter(MenuAdapter());
    Hive.registerAdapter(ModifierGroupAdapter());
    Hive.registerAdapter(ModifierAdapter());

    await Hive.initFlutter();

    final tokenBox = await Hive.openBox<Token>(HiveHeaders.tokensNameBox);
    final menuBox = await Hive.openBox<Menu>(HiveHeaders.menuNameBox);
    await Hive.openBox<ModifierGroup>(HiveHeaders.modifierGroupNameBox);
    await Hive.openBox<Modifier>(HiveHeaders.modifierNameBox);
    // final orderBox = await Hive.openBox<Modifier>(HiveHeaders.orderNameBox);

    final dio = Dio();

    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.sendTimeout = const Duration(seconds: 5);

    dio.interceptors
        .add(InterceptorsWrapper(onError: (DioException e, handler) {
      GetIt.I<Talker>().error('Dio Error: ${e.message}', e, e.stackTrace);
      return handler.next(e);
    }));

    dio.interceptors.add(
      TalkerDioLogger(
        talker: talker,
        settings: const TalkerDioLoggerSettings(
            printResponseData: false, printResponseTime: true),
      ),
    );

    Bloc.observer = TalkerBlocObserver(
      talker: talker,
      settings: const TalkerBlocLoggerSettings(
        printStateFullData: false,
        printEventFullData: false,
      ),
    );

    GetIt.I.registerLazySingleton<AbstractMenuRepository>(
      () => MenuRepository(
        dio: dio,
        menuBox: menuBox,
        apiSiteUrl: apiSiteUrl,
      ),
    );

    // Регистрация репозиториев для admin
    GetIt.I.registerLazySingleton<CategoriesRepository>(
      () => CategoriesRepository(dio: dio, apiSiteUrl: apiSiteUrl),
    );
    GetIt.I.registerLazySingleton<ProductRepository>(
      () => ProductRepository(dio: dio, apiSiteUrl: apiSiteUrl),
    );
    GetIt.I.registerLazySingleton<ProductVariantRepository>(
      () => ProductVariantRepository(dio: dio, apiSiteUrl: apiSiteUrl),
    );
    GetIt.I.registerLazySingleton<ModifierRepository>(
      () => ModifierRepository(dio: dio, apiSiteUrl: apiSiteUrl),
    );
    GetIt.I.registerLazySingleton<ModifierGroupRepository>(
      () => ModifierGroupRepository(dio: dio, apiSiteUrl: apiSiteUrl),
    );
    GetIt.I.registerLazySingleton<ModifierGroupAssociationRepository>(
      () =>
          ModifierGroupAssociationRepository(dio: dio, apiSiteUrl: apiSiteUrl),
    );
    GetIt.I.registerLazySingleton<AbstractComboItemsRepository>(
      () => ComboItemsRepository(dio: dio, apiSiteUrl: apiSiteUrl),
    );

    GetIt.I.registerSingleton<AbstractLoginRepository>(
      LoginRepository(
        dio: dio,
        tokenBox: tokenBox,
        apiSiteUrl: apiSiteUrl,
      ),
    );

    GetIt.I.registerSingleton<AbstractJWTTokensRepository>(
      JWTTokensRepository(
        dio: dio,
        tokenBox: tokenBox,
        apiSiteUrl: apiSiteUrl,
      ),
    );

    GetIt.I.registerSingleton<AbstractProfileRepository>(
      ProfileRepository(
        dio: dio,
        apiSiteUrl: apiSiteUrl,
      ),
    );

    GetIt.I.registerLazySingleton<AbstractCartRepository>(
      () => CartRepository(dio: dio, apiSiteUrl: apiSiteUrl),
    );

    GetIt.I.registerLazySingleton<AbstractOrdersRepository>(
      () => OrdersRepository(dio: dio, apiSiteUrl: apiSiteUrl),
    );

    // GetIt.I.registerSingleton<AbstractOrderRepository>(
    //   OrderRepository(
    //     dio: dio,
    //     orderBox: orderBox,
    //     apiSiteUrl: apiSiteUrl,
    //   ),
    // );

    FlutterError.onError =
        (details) => GetIt.I<Talker>().handle(details.exception, details.stack);

    if (defaultTargetPlatform == TargetPlatform.android) {
      try {
        await SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.edgeToEdge,
        );

        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);

        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.transparent,
          ),
        );
      } catch (e, st) {
        GetIt.I<Talker>().handle(e, st);
      }
    }

    try {
      runApp(const FlutterApplicationRestaraunt());
    } catch (e, st) {
      GetIt.I<Talker>().handle(e, st);
      print('Error in runApp: $e\n$st');
    }
  }, (e, st) {
    GetIt.I<Talker>().handle(e, st);
    print('Uncaught Error: $e');
  });
}
