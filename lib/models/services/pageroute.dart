import 'package:flutter/cupertino.dart';

class SlidePageRoute extends PageRouteBuilder {
  Widget widget;
  String direction;
  SlidePageRoute({required this.widget, required this.direction})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) {
            return widget;
          },
          transitionDuration: Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            switch (direction) {
              case "right":
                return new SlideTransition(
                  position: new Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              case "left":
                return new SlideTransition(
                  position: new Tween<Offset>(
                    begin: const Offset(-1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              default:
                return new SlideTransition(
                  position: new Tween<Offset>(
                    begin: const Offset(-1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
            }
          },
        );
}

class ScalePageRoute extends PageRouteBuilder {
  Widget widget;
  bool out;
  ScalePageRoute({required this.widget, required this.out})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) {
            return widget;
          },
          transitionDuration: Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return out
                ? ScaleTransition(
                    scale: new Tween<double>(
                      begin: 0.5,
                      end: 1.0,
                    ).animate(animation),
                    child: child,
                  )
                : ScaleTransition(
                    scale: new Tween<double>(
                      begin: 1.5,
                      end: 1.0,
                    ).animate(animation),
                    child: child,
                  );
          },
        );
}
