class Song {
  int? id;
  String title;
  String content;
  // DateTime modifiedTime;

  Song({
    this.id,
    required this.title,
    required this.content,
  });

  Map<String, dynamic> toJson() {
  return {
    'title': title,
    'content': content,
  };
  }
}
