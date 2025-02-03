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

  Future<String> toggleAlarm() async {
    _isAlarmOn = !_isAlarmOn;
    var msg = '';

    if (_isAlarmOn) {
      await workmanagerService.runPeriodicTask();
      if (workmanagerService.localNotificationProvider != null) {
        final randomRestaurant = await _getRandomRestaurant();
        if (randomRestaurant != null) {
          await workmanagerService.localNotificationProvider
              .scheduleDailyElevenAMNotification(randomRestaurant);
          msg =
              "Alarm ON: Notification scheduled for 11 AM daily with random restaurant.";
        }
      }
    } else {
      await workmanagerService.cancelAllTask();
      await workmanagerService.localNotificationProvider.cancelNotification();
      msg = "Alarm OFF: All tasks and notifications canceled.";
    }

    await alarmRepository.setAlarm(_isAlarmOn);
    notifyListeners();
    return msg;
  }

  Future<RestaurantInfo?> _getRandomRestaurant() async {
    try {
      final restaurantList = await RestaurantRepository(
              remoteDataSource: RestaurantRemoteDataSource())
          .fetchRestaurantList();
      if (restaurantList.restaurants.isNotEmpty) {
        final randomIndex = Random().nextInt(restaurantList.restaurants.length);
        return restaurantList.restaurants[randomIndex];
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
