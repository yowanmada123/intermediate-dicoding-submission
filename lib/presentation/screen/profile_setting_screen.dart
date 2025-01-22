import 'package:flutter/material.dart';
import 'package:maresto/core/constants/navigation_route.dart';
import 'package:maresto/data/models/received_notification.dart';
import 'package:maresto/data/providers/alarm_provider.dart';
import 'package:maresto/data/providers/local_notification_provider.dart';
import 'package:maresto/data/providers/payload_provider.dart';
import 'package:maresto/data/providers/theme_provider.dart';
import 'package:maresto/data/services/local_notification_service.dart';
import 'package:provider/provider.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) {
      context.read<PayloadProvider>().payload = payload;
      Navigator.pushNamed(context, NavigationRoute.detailNotificationRoute.name,
          arguments: payload);
    });
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationStream.stream
        .listen((ReceivedNotification receivedNotification) {
      final payload = receivedNotification.payload;
      context.read<PayloadProvider>().payload = payload;
      Navigator.pushNamed(context, NavigationRoute.detailNotificationRoute.name,
          arguments: receivedNotification.payload);
    });
  }

  @override
  void initState() {
    super.initState();
    _configureSelectNotificationSubject();
    _configureDidReceiveLocalNotificationSubject();
  }

  @override
  void dispose() {
    selectNotificationStream.close();
    didReceiveLocalNotificationStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Maresto Setting",
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const Divider(),
              ListTile(
                leading: Icon(
                  themeState.isDarkTheme ? Icons.dark_mode : Icons.light_mode,
                ),
                title: Text(themeState.isDarkTheme
                    ? "Change To Light Mode"
                    : "Change To Dark Mode"),
                trailing: Switch(
                  value: themeState.isDarkTheme,
                  onChanged: (value) {
                    themeState.toggleTheme();
                  },
                ),
              ),
              const Divider(),
              Consumer<AlarmProvider>(
                builder: (context, alarmProvider, child) {
                  return ListTile(
                    leading: Icon(
                      alarmProvider.isAlarmOn ? Icons.alarm : Icons.alarm_off,
                    ),
                    title: Text(alarmProvider.isAlarmOn
                        ? "Alarm is on Set"
                        : "Alarm Off"),
                    trailing: Switch(
                      value: alarmProvider.isAlarmOn,
                      onChanged: (value) async {
                        await _requestPermission();
                        await alarmProvider.toggleAlarm();
                      },
                    ),
                  );
                },
              ),
              const Divider(),

              // ElevatedButton(
              //   onPressed: () async {
              //     await _scheduleDailyElevenAMNotification();
              //   },
              //   child: const Text(
              //     "Schedule daily 10:00:00 am notification",
              //     textAlign: TextAlign.center,
              //   ),
              // ),
              // ElevatedButton(
              //   onPressed: () async {
              //     await _checkPendingNotificationRequests();
              //   },
              //   child: const Text(
              //     "Check pending notifications",
              //     textAlign: TextAlign.center,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _requestPermission() async {
    context.read<LocalNotificationProvider>().requestPermissions();
  }

  Future<void> _scheduleDailyElevenAMNotification() async {
    context
        .read<LocalNotificationProvider>()
        .scheduleDailyElevenAMNotification();
  }

  Future<void> _checkPendingNotificationRequests() async {
    final localNotificationProvider = context.read<LocalNotificationProvider>();
    await localNotificationProvider.checkPendingNotificationRequests(context);

    if (!mounted) {
      return;
    }

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        final pendingData = context.select(
            (LocalNotificationProvider provider) =>
                provider.pendingNotificationRequests);
        return AlertDialog(
          title: Text(
            '${pendingData.length} pending notification requests',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          content: SizedBox(
            height: 300,
            width: 300,
            child: ListView.builder(
              itemCount: pendingData.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = pendingData[index];
                return ListTile(
                  title: Text(
                    item.title ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    item.body ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  contentPadding: EdgeInsets.zero,
                  trailing: IconButton(
                    onPressed: () {
                      localNotificationProvider
                        ..cancelNotification()
                        ..checkPendingNotificationRequests(context);
                    },
                    icon: const Icon(Icons.delete_outline),
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
