class Message {
  final String text;
  final DateTime clienttimestamp;
  final bool isLoading;
  final bool isRead;
  final bool isClient;
  final bool isCartView;
  final bool isAdressPhoneNumber;
  final bool isProductsDisplay;
  final String? orderId;
  final List<String> tags; // Add tags property

  Message({
    required this.text,
    DateTime? clienttimestamp,
    this.isRead = false,
    this.isClient = true,
    this.isLoading = false,
    this.isCartView = false,
    this.isProductsDisplay = false,
    this.isAdressPhoneNumber = false,
    this.orderId,
    this.tags = const [], 
  }) : clienttimestamp = clienttimestamp ?? DateTime.now();

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      text: map['text'] ?? '',
      isClient: map['isClient'] ?? true,
      isRead: map['isRead'] ?? false,
      isLoading: map['isLoading'] ?? false,
      isCartView: map['isCartView'] ?? false,
      isAdressPhoneNumber: map['isAdressPhoneNumber'] ?? false,
      isProductsDisplay: map['isProductsDisplay'] ?? false,
      clienttimestamp: map['clienttimestamp'] != null
          ? DateTime.parse(map['clienttimestamp'])
          : DateTime.now(),
      orderId: map['orderId'] ?? '', // Fixed from map['text'] to map['orderId']
      tags: List<String>.from(map['tags'] ?? []), // Add tags conversion
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'clienttimestamp': clienttimestamp.toIso8601String(),
      'isClient': isClient,
      'isRead': isRead,
      'isLoading': isLoading,
      'isCartView': isCartView,
      'isAdressPhoneNumber': isAdressPhoneNumber,
      'isProductsDisplay': isProductsDisplay,
      'orderId': orderId,
      'tags': tags, // Add tags to map
    };
  }
}
