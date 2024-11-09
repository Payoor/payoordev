class Message {
  final String text;
  final DateTime timestamp;
  final bool isRead;

  Message({
    required this.text,
    DateTime? timestamp,
    this.isRead = false,
  }) : timestamp = timestamp ?? DateTime.now();
}
