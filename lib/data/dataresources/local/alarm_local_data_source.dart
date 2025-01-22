import 'package:shared_preferences/shared_preferences.dart';

class AlarmLocalDataSource {
  static const _alarmKey = 'isAlarmOn';

  Future<bool> getAlarmPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_alarmKey) ?? false;
  }

  Future<void> setAlarmPreference(bool isOn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_alarmKey, isOn);
  }
}
