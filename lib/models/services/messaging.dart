import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
FirebaseMessaging messaging = FirebaseMessaging.instance;

class Messaging {
  final BuildContext context;
  final Function updateHome;
  Messaging({required this.context, required this.updateHome});
}

Future<dynamic> myForgroundMessageHandler(RemoteMessage message) async {}
