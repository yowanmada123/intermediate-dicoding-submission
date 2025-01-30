import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maresto/core/constants/my_workmanager.dart';
import 'package:maresto/data/dataresources/remote/restaurant_remote_data_source.dart';
import 'package:maresto/data/providers/local_notification_provider.dart';
import 'package:maresto/data/repositories/remote/restaurant_repository.dart';
import 'package:maresto/data/services/http_service.dart';
import 'package:maresto/data/services/local_notification_service.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask(
    (task, inputData) async {
      final httpService = HttpService();
      final localNotificationService = LocalNotificationService(httpService);

      final randomRestaurant = await RestaurantRepository(
              remoteDataSource: RestaurantRemoteDataSource())
          .fetchRestaurantList();
      if (randomRestaurant.restaurants.isNotEmpty) {
        final randomIndex =
            Random().nextInt(randomRestaurant.restaurants.length);
        final restaurant = randomRestaurant.restaurants[randomIndex];

        await localNotificationService.scheduleDailyElevenAMNotification(
            id: 1,
            channelId: "3",
            channelName: "Schedule Notification",
            restaurant: restaurant);
      }
      return Future.value(true);
    },
  );
}

class WorkmanagerService {
  final Workmanager _workmanager;
  final LocalNotificationProvider localNotificationProvider;

  WorkmanagerService({
    Workmanager? workmanager,
    required this.localNotificationProvider,
  }) : _workmanager = workmanager ?? Workmanager();

  Future<void> init() async {
    await _workmanager.initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
  }

  Future<void> runOneOffTask() async {
    await _workmanager.registerOneOffTask(
      MyWorkmanager.oneOff.uniqueName,
      MyWorkmanager.oneOff.taskName,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      initialDelay: const Duration(seconds: 5),
      inputData: {
        "data": "This is a payload from one-off task",
      },
    );
    debugPrint("One-off task registered");
  }

  Future<void> runPeriodicTask() async {
    await _workmanager.registerPeriodicTask(
      MyWorkmanager.periodic.uniqueName,
      MyWorkmanager.periodic.taskName,
      frequency: const Duration(minutes: 15),
      inputData: {
        "data": "This is a payload from periodic task",
      },
    );
  }

  Future<void> cancelAllTask() async {
    await _workmanager.cancelAll();
    debugPrint("All tasks canceled");
  }
}
