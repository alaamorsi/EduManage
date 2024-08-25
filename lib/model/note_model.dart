class NoteModel {
  late String title;
  late String body;
  late String time;

  NoteModel({required this.title, required this.body, required this.time});

  NoteModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    time = json['time'];
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'time': time,
    };
  }
}
