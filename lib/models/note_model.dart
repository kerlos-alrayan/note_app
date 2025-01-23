class Note {
  int? id;
  String title;
  String content;
  int isArchived;
  int isFavorite;

  // Constructor
  Note({
    this.id,
    required this.title,
    required this.content,
    this.isArchived = 0,
    this.isFavorite = 0,
  });

  set setArchived(int value) {
    isArchived = value;
  }

  int get getArchived => isArchived;

  set setFavorite(int value) {
    isFavorite = value;
  }

  int get getFavorite => isFavorite;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'isArchived': isArchived,
      'isFavorite': isFavorite,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      isArchived: map['isArchived'],
      isFavorite: map['isFavorite'],
    );
  }
}
