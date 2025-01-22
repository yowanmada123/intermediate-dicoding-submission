import 'package:flutter/material.dart';
import 'package:maresto/core/constants/navigation_route.dart';
import 'package:maresto/data/dataresources/local/alarm_local_data_source.dart';
import 'package:maresto/data/dataresources/local/sqflite_service.dart';
import 'package:maresto/data/dataresources/local/theme_local_data_source.dart';
import 'package:maresto/data/dataresources/remote/restaurant_remote_data_source.dart';
import 'package:maresto/data/providers/alarm_provider.dart';
import 'package:maresto/data/providers/index_nav_provider.dart';
import 'package:maresto/data/providers/local_notification_provider.dart';
import 'package:maresto/data/providers/payload_provider.dart';
import 'package:maresto/data/providers/restaurant_favorite_provider.dart';
import 'package:maresto/data/providers/restaurant_provider.dart';
import 'package:maresto/data/providers/restaurant_detail_provider.dart';
import 'package:maresto/data/providers/theme_provider.dart';
import 'package:maresto/data/repositories/local/alarm_local_data_source.dart';
import 'package:maresto/data/repositories/local/favorite_restaurant_data_source.dart';
import 'package:maresto/data/repositories/local/theme_local_data_source.dart';
import 'package:maresto/data/repositories/remote/restaurant_repository.dart';
import 'package:maresto/data/services/http_service.dart';
import 'package:maresto/data/services/local_notification_service.dart';
import 'package:maresto/data/services/workmanager_service.dart';
import 'package:maresto/presentation/screen/main_screen.dart';
import 'package:maresto/presentation/screen/profile_setting_screen.dart';
import 'package:maresto/presentation/themes/theme_dark.dart';
import 'package:maresto/presentation/themes/theme_light.dart';
import 'package:maresto/presentation/screen/detail_screen.dart';
import 'package:provider/provider.dart';

void main() {
  final remoteDataSource = RestaurantRemoteDataSource();
  final repository = RestaurantRepository(remoteDataSource: remoteDataSource);

  String? payload;

  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (context) => HttpService(),
        ),
        Provider(
          create: (context) => LocalNotificationService(
            context.read<HttpService>(),
          )
            ..init()
            ..configureLocalTimeZone(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocalNotificationProvider(
            context.read<LocalNotificationService>(),
          )..requestPermissions(),
        ),
        ChangeNotifierProvider(
          create: (context) => PayloadProvider(
            payload: payload,
          ),
        ),
        Provider(
          create: (context) => WorkmanagerService(
            localNotificationProvider:
                context.read<LocalNotificationProvider>(),
          )..init(),
        ),
        ChangeNotifierProvider(
          create: (_) => RestaurantProvider(repository: repository),
        ),
        ChangeNotifierProvider(
          create: (_) => RestaurantDetailProvider(repository: repository),
        ),
        ChangeNotifierProvider(create: (_) => IndexNavProvider()),
        Provider<ThemeLocalDataSource>(
          create: (_) => ThemeLocalDataSource(),
        ),
        Provider<ThemeRepository>(
          create: (context) => ThemeRepository(
            context.read<ThemeLocalDataSource>(),
          ),
        ),
        ChangeNotifierProvider(
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
        ChangeNotifierProvider(
          create: (context) => AlarmProvider(
            context.read<AlarmRepository>(),
            context.read<WorkmanagerService>(),
          ),
        ),
        Provider<FavoriteRepository>(
          create: (_) => FavoriteRepository(SqliteService.instance),
        ),
        ChangeNotifierProvider(
          create: (context) => FavoriteRestaurantProvider(
            context.read<FavoriteRepository>(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Maresto',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: themeViewModel.currentTheme,
      initialRoute: NavigationRoute.mainRoute.name,
      routes: {
        NavigationRoute.mainRoute.name: (context) => const MainScreen(),
        NavigationRoute.detailRoute.name: (context) => DetailScreen(
              restaurantId:
                  ModalRoute.of(context)?.settings.arguments as String,
            ),
        NavigationRoute.settingRoute.name: (context) =>
            const ProfileSettingsPage(),
      },
    );
  }
}
