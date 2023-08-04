class NotesModel {
  String? id;
  String? email;
  String? title;
  String? content;
  DateTime? dateAdded;

  NotesModel({this.id, this.email, this.title, this.content, this.dateAdded});

  factory NotesModel.fromMap(Map<String, dynamic> map) {
    return NotesModel(
      id: map["_id"],
      email: map["email"],
      title: map["title"],
      content: map["content"],
      dateAdded: DateTime.tryParse(map["dateAdded"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "title": title,
      "content": content,
      "dateAdded": dateAdded?.toIso8601String(),
    };
  }
}
