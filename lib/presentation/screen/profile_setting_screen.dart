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
  final ThemeProvider? themeProvider;
  final AlarmProvider? alarmProvider;

  const ProfileSettingsPage({
    super.key,
    this.themeProvider,
    this.alarmProvider,
  });

  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  @override
  void initState() {
    super.initState();
    _configureSelectNotificationSubject();
    _configureDidReceiveLocalNotificationSubject();
  }

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
  void dispose() {
    selectNotificationStream.close();
    didReceiveLocalNotificationStream.close();
    super.dispose();
  }

  Future<void> _requestPermission({LocalNotificationProvider? provider}) async {
    final notificationProvider =
        provider ?? context.read<LocalNotificationProvider>();
    notificationProvider.requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan provider injeksi atau fallback ke Provider.of
    final themeState =
        widget.themeProvider ?? Provider.of<ThemeProvider>(context);

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
              // Theme toggle
              ListTile(
                key: const Key('themeToggleTile'),
                leading: Icon(
                  themeState.isDarkTheme ? Icons.dark_mode : Icons.light_mode,
                ),
                title: Text(themeState.isDarkTheme
                    ? "Change To Light Mode"
                    : "Change To Dark Mode"),
                trailing: Switch(
                  key: const Key('themeToggleSwitch'),
                  value: themeState.isDarkTheme,
                  onChanged: (value) async {
                    await themeState.toggleTheme();
                  },
                ),
              ),
              const Divider(),
              Consumer<AlarmProvider>(
                builder: (context, alarmProvider, child) {
                  return ListTile(
                    key: const Key('alarmToggleTile'),
                    leading: Icon(
                      alarmProvider.isAlarmOn ? Icons.alarm : Icons.alarm_off,
                    ),
                    title: Text(alarmProvider.isAlarmOn
                        ? "Alarm is on Set"
                        : "Alarm Off"),
                    trailing: Switch(
                      key: const Key('alarmToggleSwitch'),
                      value: alarmProvider.isAlarmOn,
                      onChanged: (value) async {
                        await _requestPermission();
                        await alarmProvider.toggleAlarm();
                      },
                    ),
                  );
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  await _checkPendingNotificationRequests();
                },
                child: const Text(
                  "Check pending notifications",
                  textAlign: TextAlign.center,
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
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
                          // ..cancelNotification(item.id)
                          .checkPendingNotificationRequests(context);
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
