class CartItem {
  final String id;
  final String name;
  final Map<String, UnitDetails> units;

  CartItem({
    required this.id,
    required this.name,
    required this.units,
  });
}

class UnitDetails {
  final double price;
  int quantity;
  final String unit;

  UnitDetails({
    required this.price,
    this.quantity = 1,
    required this.unit
  });
}
