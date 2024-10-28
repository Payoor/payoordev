class Review {
  final String imageUrl;
  final String name;
  final String content;

  Review({
    required this.imageUrl,
    required this.name,
    required this.content,
  });

  // Factory constructor to create a Review object from a Map
  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      imageUrl: map['imageUrl'] as String,
      name: map['name'] as String,
      content: map['content'] as String,
    );
  }

  // Method to convert a Review object to a Map
  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'name': name,
      'content': content,
    };
  }

  // Override toString for easier debugging
  @override
  String toString() {
    return 'Review(imageUrl: $imageUrl, name: $name, content: $content)';
  }
}