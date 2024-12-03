import 'package:flutter/material.dart';

import 'package:chatuiv2/src/classes/_cartitem.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  void addItem({
    required String id,
    required String name,
    required String unit,
    required double price,
  }) {
    if (_items.containsKey(id)) {
      final existingItem = _items[id]!;

      if (existingItem.units.containsKey(unit)) {
        existingItem.units[unit]!.quantity++;
      } else {
        existingItem.units[unit] = UnitDetails(price: price, quantity: 1);
      }
    } else {
      _items.putIfAbsent(
        id,
        () => CartItem(
          id: id,
          name: name,
          units: {
            unit: UnitDetails(price: price),
          },
        ),
      );
    }
    notifyListeners();
  }

  int quantityAmount({required String unit, required String id}) {
    if (!_items.containsKey(id)) return 0;
    if (!_items[id]!.units.containsKey(unit)) return 0;
    return _items[id]!.units[unit]!.quantity;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, item) {
      item.units.forEach((unit, details) {
        total += details.price * details.quantity;
      });
    });

    return total;
  }

  void decreaseItem({
    required String id,
    required String unit,
  }) {
    if (!_items.containsKey(id)) return;

    final existingItem = _items[id]!;

    if (existingItem.units.containsKey(unit)) {
      if (existingItem.units[unit]!.quantity > 1) {
        existingItem.units[unit]!.quantity--;
      } else {
        existingItem.units.remove(unit);

        if (existingItem.units.isEmpty) {
          _items.remove(id);
        }
      }
      notifyListeners();
    }
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
