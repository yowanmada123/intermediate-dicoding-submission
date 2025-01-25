import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maresto/data/dataresources/remote/restaurant_remote_data_source.dart';
import 'package:maresto/data/models/restaurant_list_response.dart';
import 'package:maresto/data/repositories/local/alarm_local_data_source.dart';
import 'package:maresto/data/repositories/remote/restaurant_repository.dart';
import 'package:maresto/data/services/workmanager_service.dart';

class AlarmProvider extends ChangeNotifier {
  final AlarmRepository alarmRepository;
  final WorkmanagerService workmanagerService;

  bool _isAlarmOn = false;

  bool get isAlarmOn => _isAlarmOn;

  AlarmProvider(this.alarmRepository, this.workmanagerService) {
    _loadAlarm();
  }

  Future<void> _loadAlarm() async {
    _isAlarmOn = await alarmRepository.getAlarm();

    if (_isAlarmOn) {
      await workmanagerService.runPeriodicTask();
    }
    notifyListeners();
  }

  Future<void> toggleAlarm() async {
    _isAlarmOn = !_isAlarmOn;

    if (_isAlarmOn) {
      await workmanagerService.runPeriodicTask();
      if (workmanagerService.localNotificationProvider != null) {
        final randomRestaurant = await _getRandomRestaurant();
        if (randomRestaurant != null) {
          await workmanagerService.localNotificationProvider
              .scheduleDailyElevenAMNotification(randomRestaurant);
          debugPrint(
              "Alarm ON: Notification scheduled for 11 AM daily with random restaurant.");
        }
        debugPrint("localNotificationProvider is null.");
      }
    } else {
      await workmanagerService.cancelAllTask();
      await workmanagerService.localNotificationProvider.cancelNotification();
      debugPrint("Alarm OFF: All tasks and notifications canceled.");
    }

    await alarmRepository.setAlarm(_isAlarmOn);
    notifyListeners();
  }

  Future<RestaurantInfo?> _getRandomRestaurant() async {
    try {
      final restaurantList = await RestaurantRepository(
              remoteDataSource: RestaurantRemoteDataSource())
          .fetchRestaurantList();
      if (restaurantList.restaurants.isNotEmpty) {
        // Pilih restoran acak
        final randomIndex = Random().nextInt(restaurantList.restaurants.length);
        return restaurantList.restaurants[randomIndex];
      }
    } catch (e) {
      debugPrint("Error fetching random restaurant: $e");
    }
    return null;
  }
}
