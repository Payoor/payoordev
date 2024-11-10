class Message {
  final String text;
  final DateTime clienttimestamp;
  final bool isRead;
  final bool isClient;

  Message({
    required this.text,
    DateTime? clienttimestamp,
    this.isRead = false,
    this.isClient = true,
  }) : clienttimestamp = clienttimestamp ?? DateTime.now();

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      text: map['text'] ?? '',
      isClient: map['isClient'] ?? true,
      isRead: map['isRead'] ?? false,
      clienttimestamp: map['clienttimestamp'] ?? DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'Message(text: $text, clienttimestamp: ${clienttimestamp.toIso8601String()}, isRead: $isRead, isClient: $isClient)';
  }
}
