class Conseil {
  final String title;
  // final String description;

  Conseil({
    required this.title,
    // required this.description,
  });

  // Method to convert a Conseil object to a map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      // 'description': description,
    };
  }

  // Method to create a Conseil object from a map
  factory Conseil.fromMap(Map<String, dynamic> map) {
    return Conseil(
      title: map['title'],
      // description: map['description'],
    );
  }
}