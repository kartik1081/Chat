import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:textme/models/services/pageroute.dart';
import 'package:textme/presentation/pages/homepage.dart';

class LocalNotification {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/launcher_icon"));
    _plugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) async {
        if (payload == "Home Page") {
          Navigator.push(
              context, ScalePageRoute(widget: HomePage(), out: false));
        }
      },
    );
  }

  static void display(
      RemoteMessage message, AndroidNotificationChannel channel) async {
    try {
      await _plugin.show(
          message.data.hashCode,
          message.data["title"],
          message.data["body"],
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
            ),
          ));
    } catch (e) {
      print(e.toString());
    }
  }
}
