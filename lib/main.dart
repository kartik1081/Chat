import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:textme/pages/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Color(0xFF2B2641),
            appBarTheme: AppBarTheme(
              titleTextStyle: TextStyle(color: Colors.white70),
              textTheme: TextTheme(
                caption: TextStyle(color: Colors.white70),
              ),
              titleSpacing: 4.0.w,
              color: Color(0xFF2B2641),
              elevation: 1,
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              actionsIconTheme:
                  IconThemeData(color: Colors.white70, size: 4.sp),
            ),
          ),
          title: 'TextMe',
          home: Splash(),
        );
      },
    );
  }
}
