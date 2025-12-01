import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class BottomNavigatorProvider with ChangeNotifier {
  int _index = 2;

  int get index => _index;

  set index(int newIndex) {
    _index = newIndex;
    notifyListeners();
  }
  String formatarNumero(num number) {
  double value = number.toDouble();
  if (value >= 1000000) {
    value /= 1000000;
   return '${NumberFormat('0.0', 'pt_BR').format(value)}M';
  } else if (value >= 1000) {
    value /= 1000;
   return '${NumberFormat('0.0', 'pt_BR').format(value)}K';
  } else {
    return NumberFormat('0.#', 'pt_BR').format(value);
  }
}
}