import 'package:flutter/cupertino.dart';

class DesktopHomeScreenService extends ChangeNotifier {
  int currentIndex = 1;

  void moveTo(int view) {
    currentIndex = view;
    notifyListeners();
  }
}
