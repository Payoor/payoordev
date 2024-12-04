class Product {
  final String id;
  final Map<String, dynamic> data;
  final List<String> images;
  final String generatedDescription;
  final List<String> generatedCategories;

  Product({
    required this.id,
    required this.data,
    required this.images,
    required this.generatedDescription,
    required this.generatedCategories,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['_id'] ?? '',
      data: Map<String, dynamic>.from(map['data'] ?? {}),
      images: List<String>.from(map['images'] ?? []),
      generatedDescription: map['generatedDescription'] ?? '',
      generatedCategories: List<String>.from(map['generatedCategories'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'data': data,
      'images': images,
      'generatedDescription': generatedDescription,
      'generatedCategories': generatedCategories,
    };
  }
}