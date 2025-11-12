import 'package:flutter/foundation.dart';

class BottomNavigatorProvider with ChangeNotifier {
  int _index = 2;

  int get index => _index;

  set index(int newIndex) {
    _index = newIndex;
    notifyListeners();
  }
}