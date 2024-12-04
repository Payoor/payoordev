class Message {
  final String text;
  final DateTime clienttimestamp;
  final bool isLoading;
  final bool isRead;
  final bool isClient;
  final bool isPayStackView;
  final bool isProductsDisplay;
  final List<Map<String, dynamic>> results; 

  Message({
    required this.text,
    DateTime? clienttimestamp,
    this.isRead = false,
    this.isClient = true,
    this.isLoading = false,
    this.isPayStackView = false,
    this.isProductsDisplay = false,
    this.results = const [],
  }) : clienttimestamp = clienttimestamp ?? DateTime.now();

  factory Message.fromMap(Map<String, dynamic> map) {
    var rawProducts = map['results'] ?? [];
    List<Map<String, dynamic>> parsedProducts = [];

    if (rawProducts is List) {
      parsedProducts = rawProducts.map<Map<String, dynamic>>((product) {
        return {
          '_id': product['_id'] ?? '',
          'data': Map<String, dynamic>.from(product['data'] ?? {}),
          'images': List<String>.from(product['images'] ?? []),
          'generatedDescription': product['generatedDescription'] ?? '',
          'generatedCategories': List<String>.from(product['generatedCategories'] ?? []),
        };
      }).toList();
    }

    return Message(
      text: map['text'] ?? '',
      isClient: map['isClient'] ?? true,
      isRead: map['isRead'] ?? false,
      isLoading: map['isLoading'] ?? false,
      isPayStackView: map['isPayStackView'] ?? false,
      isProductsDisplay: map['isProductsDisplay'] ?? false,
      clienttimestamp: map['clienttimestamp'] != null
          ? DateTime.parse(map['clienttimestamp'])
          : DateTime.now(),
      results: parsedProducts,
    );
  }
}