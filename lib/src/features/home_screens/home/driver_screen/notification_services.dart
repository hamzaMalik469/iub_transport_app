import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:transport_app_iub/src/constants/images_strings.dart';

class NotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    // Initialization for notifications (required for Android)
    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(wellcomeScreenImage); // Add your app icon
    InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> startForegroundService() async {
    FlutterBackgroundService().startService();

    // Create notification details
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'your_channel_id', // Channel ID
      'Vehicle Tracking', // Channel name
      channelDescription: 'Tracking vehicle in the background',
      importance: Importance.high,
      priority: Priority.high,
      ongoing: true, // Keeps the notification persistent
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    // Show the notification
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Vehicle Tracking', // Title
      'Tracking is active', // Body text
      notificationDetails,
    );
  }

  static Future<void> stopForegroundService() async {
    FlutterBackgroundService().sendData({"action": "stopService"});
    flutterLocalNotificationsPlugin.cancel(0); // Remove the notification
  }
}

extension on FlutterBackgroundService {
  void sendData(Map<String, String> map) {}
}
