import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
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


import 'dart:io' show Platform;

void main() async {
  // await dotenv.load(fileName: ".env");
  // final apiSiteUrl = dotenv.env['API_SITE_URL'] ?? 'http://127.0.0.1:8000';
  final apiSiteUrl = 'http://127.0.0.1:8000';

  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.ensureVisualUpdate();

    if (!kIsWeb) {
      SystemChannels.textInput.invokeMethod('TextInput.setImeHidden', true);
    } else if(kIsWeb){
      setUrlStrategy(PathUrlStrategy());
    }
    
    final talker = TalkerFlutter.init();
    GetIt.I.registerSingleton(talker);
    GetIt.I<Talker>().debug('Talker started...');

    await Hive.initFlutter();
    
    Hive.registerAdapter(UidManagerAdapter());
    final uidManagerBox = await Hive.openBox<Token>(HiveHeaders.uidManagerNameBox);
    
    Hive.registerAdapter(TokenAdapter());
    final tokenBox = await Hive.openBox<Token>(HiveHeaders.tokensNameBox);
    
    Hive.registerAdapter(ProductAdapter());
    
    Hive.registerAdapter(CategoryAdapter());
    
    final productsBox = await Hive.openBox<Product>(HiveHeaders.productsNameBox);
    
    
    Hive.registerAdapter(CartAdapter());
    final cartsBox = await Hive.openBox<Cart>(HiveHeaders.cartsNameBox);

    final dio = Dio();
    
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.sendTimeout = const Duration(seconds: 5);
    
    dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException e, handler) {
        GetIt.I<Talker>().error('Dio Error: ${e.message}', e, e.stackTrace);
        return handler.next(e);
      }
    ));
    
    dio.interceptors.add(
      TalkerDioLogger(
        talker: talker,
        settings: const TalkerDioLoggerSettings(printResponseData: false, printResponseTime: true),
      ),
    );

    Bloc.observer = TalkerBlocObserver(
      talker: talker,
      settings: const TalkerBlocLoggerSettings(
        printStateFullData: false,
        printEventFullData: false,
      ),
    );

    GetIt.I.registerLazySingleton<AbstractProductsRepository>(
      () => ProductsRepository(
        dio: dio,
        productsBox: productsBox,
        apiSiteUrl: apiSiteUrl,
      ),
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
    
    GetIt.I.registerSingleton<AbstractCartsRepository>(
      CartsRepository(
        dio: dio,
        cartsBox: cartsBox,
        apiSiteUrl: apiSiteUrl,
      ),
    );

    FlutterError.onError =
        (details) => GetIt.I<Talker>().handle(details.exception, details.stack);
        
    if (!kIsWeb && Platform.isAndroid) {
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
