import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:textme/models/Providers/authentication_provider.dart';
import 'package:textme/models/services/localnotifiacation.dart';
import 'package:textme/models/services/pageroute.dart';
import 'package:textme/presentation/pages/signin.dart';

import 'presentation/pages/homepage.dart';
import 'presentation/pages/splash.dart';

AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'ChannelId', // id
  'ChannelId', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

//Receive message while app is on background mode...
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print(message.data);
  LocalNotification.display(message, channel);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => Authentication(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Save the initial token to the database
    // ignore: unnecessary_statements
    FirebaseAuth.instance.currentUser != null ? saveTokenToDatabase() : null;

    // Any time the token refreshes, store this in the database too.

    FirebaseMessaging.instance.onTokenRefresh.listen((event) {});

    // open while app is terminated...
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      if (value != null) {
        Navigator.push(context, ScalePageRoute(widget: HomePage(), out: false));
      }
    });

    //works when app is on forground...
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        LocalNotification.display(message, channel);
      }
    });

    // works when app is on background but not terminated...
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      RemoteNotification? notification = event.notification;
      AndroidNotification? android = event.notification?.android;
      if (notification != null && android != null) {
        Navigator.push(context, ScalePageRoute(widget: HomePage(), out: false));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Color(0xFF07232c),
            appBarTheme: AppBarTheme(
              titleTextStyle: TextStyle(color: Colors.white70),
              textTheme: TextTheme(
                caption: TextStyle(color: Colors.white70),
              ),
              titleSpacing: 4.0.w,
              color: Color(0xFF07232c),
              elevation: 1,
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              actionsIconTheme:
                  IconThemeData(color: Colors.white70, size: 4.sp),
            ),
          ),
          title: 'TextMe',
          home: _auth(),
        );
      },
    );
  }

  Widget _auth() {
    return FirebaseAuth.instance.currentUser != null ? HomePage() : SignIn();
  }

  saveTokenToDatabase() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "msgToken":
          FieldValue.arrayUnion([await FirebaseMessaging.instance.getToken()])
    });
  }
}
