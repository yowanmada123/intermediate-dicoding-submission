import 'package:flutter/material.dart';
import 'package:maresto/data/repositories/local/alarm_local_data_source.dart';
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
        await workmanagerService.localNotificationProvider
            .scheduleDailyElevenAMNotification();
        debugPrint("Alarm ON: Notification scheduled for 11 AM daily.");
      } else {
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
}
