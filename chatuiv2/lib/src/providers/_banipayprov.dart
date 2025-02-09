import 'package:flutter/material.dart';

class BaniPayProvider with ChangeNotifier {
  dynamic _currentOrder;

  dynamic get currentOrder => _currentOrder;

  set currentOrder(dynamic order) {
    _currentOrder = order;
    notifyListeners();
  }

  dynamic getCurrentOrder() {
    return _currentOrder;
  }

  void setCurrentOrder(dynamic order) {
    _currentOrder = order;
    notifyListeners();
  }

  void clearCurrentOrder() {
    _currentOrder = null;
    notifyListeners();
  }

  bool hasCurrentOrder() {
    return _currentOrder != null;
  }
}
