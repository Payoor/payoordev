import 'package:flutter/material.dart';

import 'package:chatuiv2/src/classes/_cartitem.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  Map<String, dynamic> createCartPayload() {
    final cartPayload = {
      'items': _items.map((id, item) => MapEntry(id, {
            'name': item.name,
            'units': item.units.map((unit, details) => MapEntry(
                unit, {'price': details.price, 'quantity': details.quantity}))
          })),
      'totalAmount': totalAmount
    };
    return cartPayload;
  }

  void printCartItems() {
    _items.forEach((id, item) {
      //print('\nItem ID: $id');
      //print('Name: ${item.name}');
      item.units.forEach((unit, details) {
        //print('Unit: $unit');
        //print('Price: ${details.price}');
        //print('Quantity: ${details.quantity}');
      });
    });
    //print('\nTotal Amount: $totalAmount');
  }

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
        existingItem.units[unit] =
            UnitDetails(price: price, quantity: 1, unit: unit);
      }
    } else {
      _items.putIfAbsent(
        id,
        () => CartItem(
          id: id,
          name: name,
          units: {
            unit: UnitDetails(price: price, unit: unit),
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

  double get serviceCharge {
    const double SERVICE_CHARGE_PERCENTAGE = 0.075;

    double charge = totalAmount * SERVICE_CHARGE_PERCENTAGE;

    return double.parse(charge.toStringAsFixed(2));
  }

  void increaseItem({
    required String id,
    required String unit,
  }) {
    if (!_items.containsKey(id)) return;

    final existingItem = _items[id]!;

    if (existingItem.units.containsKey(unit)) {
      existingItem.units[unit]!.quantity++;
      notifyListeners();
    }
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

  void deleteUnit({
    required String id,
    required String unit,
  }) {
    if (!_items.containsKey(id)) return;

    final existingItem = _items[id]!;

    if (existingItem.units.containsKey(unit)) {
      existingItem.units.remove(unit);

      if (existingItem.units.isEmpty) {
        _items.remove(id);
      }

      notifyListeners();
    }
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
