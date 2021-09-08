class Note {
  int id = 0;
  String title = '';
  String content = '';

  Note(this.id, this.title, this.content);

  Note.fromJson(Map<String, dynamic> sessionMap) {
    id = sessionMap['id'] ?? 0;
    title = sessionMap['title'] ?? '';
    content = sessionMap['content'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
    };
  }
}
