import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'core/constants/navigation_route.dart';
import 'data/dataresources/local/alarm_local_data_source.dart';
import 'data/dataresources/local/sqflite_service.dart';
import 'data/dataresources/local/theme_local_data_source.dart';
import 'data/dataresources/remote/restaurant_remote_data_source.dart';
import 'data/providers/alarm_provider.dart';
import 'data/providers/index_nav_provider.dart';
import 'data/providers/local_notification_provider.dart';
import 'data/providers/payload_provider.dart';
import 'data/providers/restaurant_detail_provider.dart';
import 'data/providers/restaurant_favorite_provider.dart';
import 'data/providers/restaurant_provider.dart';
import 'data/providers/theme_provider.dart';
import 'data/repositories/local/alarm_local_data_source.dart';
import 'data/repositories/local/favorite_restaurant_data_source.dart';
import 'data/repositories/local/theme_local_data_source.dart';
import 'data/repositories/remote/restaurant_repository.dart';
import 'data/services/http_service.dart';
import 'data/services/local_notification_service.dart';
import 'data/services/workmanager_service.dart';
import 'presentation/screen/detail_screen.dart';
import 'presentation/screen/main_screen.dart';
import 'presentation/themes/theme_dark.dart';
import 'presentation/themes/theme_light.dart';

// ignore: must_be_immutable
class RestaurantApp extends StatelessWidget {
  RestaurantApp({super.key})
      : remoteDataSource = RestaurantRemoteDataSource(),
        repository = RestaurantRepository(
            remoteDataSource: RestaurantRemoteDataSource());

  final RestaurantRemoteDataSource remoteDataSource;
  final RestaurantRepository repository;

  String? payload;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<HttpService>(
          create: (_) => HttpService(),
        ),
        Provider<LocalNotificationService>(
          create: (context) => LocalNotificationService(
            context.read<HttpService>(),
          )
            ..init()
            ..configureLocalTimeZone(),
        ),
        ChangeNotifierProvider<LocalNotificationProvider>(
          create: (context) => LocalNotificationProvider(
            context.read<LocalNotificationService>(),
          )..requestPermissions(),
        ),
        ChangeNotifierProvider<PayloadProvider>(
          create: (_) => PayloadProvider(payload: payload),
        ),
        Provider<WorkmanagerService>(
          create: (context) => WorkmanagerService(
            localNotificationProvider:
                context.read<LocalNotificationProvider>(),
          )..init(),
        ),
        ChangeNotifierProvider<RestaurantProvider>(
          create: (_) => RestaurantProvider(repository: repository),
        ),
        ChangeNotifierProvider<RestaurantDetailProvider>(
          create: (_) => RestaurantDetailProvider(repository: repository),
        ),
        ChangeNotifierProvider<IndexNavProvider>(
          create: (_) => IndexNavProvider(),
        ),
        Provider<ThemeLocalDataSource>(
          create: (_) => ThemeLocalDataSource(),
        ),
        Provider<ThemeRepository>(
          create: (context) => ThemeRepository(
            context.read<ThemeLocalDataSource>(),
          ),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(
            context.read<ThemeRepository>(),
          ),
        ),
        Provider<AlarmLocalDataSource>(
          create: (_) => AlarmLocalDataSource(),
        ),
        Provider<AlarmRepository>(
          create: (context) => AlarmRepository(
            context.read<AlarmLocalDataSource>(),
          ),
        ),
        ChangeNotifierProvider<AlarmProvider>(
          create: (context) => AlarmProvider(
            context.read<AlarmRepository>(),
            context.read<WorkmanagerService>(),
          ),
        ),
        Provider<FavoriteRepository>(
          create: (_) => FavoriteRepository(SqliteService.instance),
        ),
        ChangeNotifierProvider<FavoriteRestaurantProvider>(
          create: (context) => FavoriteRestaurantProvider(
            context.read<FavoriteRepository>(),
          ),
        ),
      ],
      child: const RestauranyAppView(),
    );
  }
}

class RestauranyAppView extends StatelessWidget {
  const RestauranyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Maresto',
          debugShowCheckedModeBanner: false,
          theme: buildLightTheme(),
          darkTheme: buildDarkTheme(),
          themeMode: themeProvider.currentTheme,
          initialRoute: NavigationRoute.mainRoute.name,
          routes: {
            NavigationRoute.mainRoute.name: (context) => const MainScreen(),
            NavigationRoute.detailRoute.name: (context) => DetailScreen(
                  restaurantId:
                      ModalRoute.of(context)?.settings.arguments as String,
                ),
          },
        );
      },
    );
  }
}
