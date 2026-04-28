class Note {
  final int? id;
  final String title;

  Note({this.id, required this.title});

  // Database mein save karne ke liye
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  // Database se data wapis lane ke liye
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
    );
  }
}