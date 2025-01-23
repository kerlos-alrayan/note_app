class Note {
  int? id;
  String title;
  String content;
  int isArchived; // 0 for not archived, 1 for archived
  int isFavorite; // 0 for not favorite, 1 for favorite

  // Constructor
  Note({
    this.id,
    required this.title,
    required this.content,
    this.isArchived = 0, // Default value is 0 (not archived)
    this.isFavorite = 0, // Default value is 0 (not favorite)
  });

  // Optionally, create a setter method if you want custom behavior
  set setArchived(int value) {
    isArchived = value;
  }

  // Optionally, you can also create getter method for 'isArchived'
  int get getArchived => isArchived;

  // Optionally, create setter and getter for 'isFavorite' if needed
  set setFavorite(int value) {
    isFavorite = value;
  }

  int get getFavorite => isFavorite;

  // Convert a Note to a map (for saving into a database or sending through APIs)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'isArchived': isArchived,
      'isFavorite': isFavorite,
    };
  }

  // Create a Note from a map (e.g., when reading from a database)
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
