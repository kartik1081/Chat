import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Messaging extends StatefulWidget {
  const Messaging({Key? key}) : super(key: key);

  @override
  _MessagingState createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  late NotificationSettings _settings;

  @override
  void initState() async {
    super.initState();
    NotificationSettings sett = await _messaging.getNotificationSettings();
    if (sett.authorizationStatus == AuthorizationStatus.denied) {
      _settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    } else {
      print('User granted permission: ${_settings.authorizationStatus}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
