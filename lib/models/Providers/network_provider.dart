import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';

class networkProvider extends ChangeNotifier {
  late bool _isNet;
  bool get isNet => _isNet;

  void checkNetwork() {
    Connectivity().onConnectivityChanged.listen((event) {
      _connectiviyResult(event);
    });
    notifyListeners();
  }

  void _connectiviyResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        _isNet = true;
        break;
      case ConnectivityResult.wifi:
        _isNet = true;
        break;
      default:
        _isNet = false;
        break;
    }
    notifyListeners();
  }
}
