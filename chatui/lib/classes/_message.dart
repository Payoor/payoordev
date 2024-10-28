class Message {
  final String value;
  final bool isUser;
  final bool isLoggedIn;
  final String? jwt;
  final String username;
  final String timeStamp;
  final String? id; // Optional ID field

  Message({
    required this.value,
    required this.isUser,
    required this.isLoggedIn,
    required this.jwt,
    required this.username,
    required this.timeStamp,
    this.id, // Optional parameter, no 'required' keyword
  });

  factory Message.fromJson(Map<String, dynamic> json,
      {required String username, required String jwt}) {
    return Message(
      value: json['content'] ?? '',
      isUser: json['isUser'] ?? false,
      isLoggedIn: json['isLoggedIn'] ?? false,
      jwt: jwt,
      username: username,
      timeStamp: json['server_timestamp'] ?? '',
      id: json['_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'message': value,
        'isUser': isUser,
        'isLoggedIn': isLoggedIn,
        'jwt': jwt,
        'username': username,
        'timestamp': timeStamp,
        'id': id, // Include ID in JSON
      };
}
