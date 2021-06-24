import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:textme/pages/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF2B2641),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(color: Colors.white70),
          textTheme: TextTheme(
            caption: new TextStyle(color: Colors.white70),
          ),
          titleSpacing: 40.0,
          color: Color(0xFF2B2641),
          elevation: 1,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          actionsIconTheme: IconThemeData(color: Colors.white70, size: 40),
        ),
      ),
      title: 'TextMe',
      home: Splash(),
    );
  }
}
