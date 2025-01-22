import 'package:maresto/data/dataresources/local/alarm_local_data_source.dart';

class AlarmRepository {
  final AlarmLocalDataSource themeLocalDataSource;

  AlarmRepository(this.themeLocalDataSource);

  Future<bool> getAlarm() async {
    return await themeLocalDataSource.getAlarmPreference();
  }

  Future<void> setAlarm(bool isOn) async {
    await themeLocalDataSource.setAlarmPreference(isOn);
  }
}
