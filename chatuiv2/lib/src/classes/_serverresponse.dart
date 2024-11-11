class ServerResponse {
  final bool success;
  final Map<String, dynamic> data;

  ServerResponse({
    required this.success,
    required this.data,
  });

  factory ServerResponse.fromJson(Map<String, dynamic> json) {
    return ServerResponse(
      success: json['success'] ?? false,
      data: json['data'] ?? {},
    );
  }
}
