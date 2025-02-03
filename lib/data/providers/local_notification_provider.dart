import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:maresto/data/models/restaurant_list_response.dart';
import 'package:maresto/data/services/local_notification_service.dart';

class LocalNotificationProvider extends ChangeNotifier {
  final LocalNotificationService flutterNotificationService;

  LocalNotificationProvider(this.flutterNotificationService);

  bool? _permission = false;
  bool? get permission => _permission;

  List<PendingNotificationRequest> pendingNotificationRequests = [];

  Future<void> requestPermissions() async {
    _permission = await flutterNotificationService.requestPermissions();
    notifyListeners();
  }

  Future<void> scheduleDailyElevenAMNotification(
      RestaurantInfo restaurant) async {
    await flutterNotificationService.scheduleDailyElevenAMNotification(
        id: 1,
        channelId: "3",
        channelName: "Schedule Notification",
        restaurant: restaurant);
  }

  Future<void> checkPendingNotificationRequests(BuildContext context) async {
    pendingNotificationRequests =
        await flutterNotificationService.pendingNotificationRequests();
    notifyListeners();
  }

  Future<void> cancelNotification() async {
    await flutterNotificationService.cancelNotification();
  }
}
