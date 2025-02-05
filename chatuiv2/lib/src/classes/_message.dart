class Message {
  final String text;
  final DateTime clienttimestamp;
  final bool isLoading;
  final bool isRead;
  final bool isClient;
  final bool isPayStackView;
  final bool isCartView;
  final bool isAdressPhoneNumber;
  final bool isProductsDisplay;
  final bool isOrderSummary;
  final List<String> results; // Changed to List<String>
  final String? paymentUrl;

  Message({
    required this.text,
    DateTime? clienttimestamp,
    this.isRead = false,
    this.isClient = true,
    this.isLoading = false,
    this.isPayStackView = false,
    this.isCartView = false,
    this.isProductsDisplay = false,
    this.isAdressPhoneNumber = false,
    this.isOrderSummary = false,
    this.results = const [], // Default empty List<String>
    this.paymentUrl,
  }) : clienttimestamp = clienttimestamp ?? DateTime.now();

  factory Message.fromMap(Map<String, dynamic> map) {
    var rawResults = map['results'] ?? [];
    List<String> parsedResults = [];

    if (rawResults is List) {
      parsedResults = rawResults.map((item) => item.toString()).toList();
    }

    return Message(
      text: map['text'] ?? '',
      isClient: map['isClient'] ?? true,
      isRead: map['isRead'] ?? false,
      isLoading: map['isLoading'] ?? false,
      isPayStackView: map['isPayStackView'] ?? false,
      isCartView: map['isCartView'] ?? false,
      isAdressPhoneNumber: map['isAdressPhoneNumber'] ?? false,
      isProductsDisplay: map['isProductsDisplay'] ?? false,
      isOrderSummary: map['isOrderSummary'] ?? false,
      clienttimestamp: map['clienttimestamp'] != null
          ? DateTime.parse(map['clienttimestamp'])
          : DateTime.now(),
      results: parsedResults,
      paymentUrl: map['paymentUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'clienttimestamp': clienttimestamp.toIso8601String(),
      'isClient': isClient,
      'isRead': isRead,
      'isLoading': isLoading,
      'isPayStackView': isPayStackView,
      'isCartView': isCartView,
      'isAdressPhoneNumber': isAdressPhoneNumber,
      'isProductsDisplay': isProductsDisplay,
      'isOrderSummary': isOrderSummary,
      'results': results,
      'paymentUrl': paymentUrl,
    };
  }
}
