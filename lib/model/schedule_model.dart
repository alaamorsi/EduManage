class ScheduleModel {
  late String subject;
  late String month;
  late String day;
  late int hour;
  late int minute;
  late String type;

  ScheduleModel(
      {required this.subject,
      required this.month,
      required this.day,
      required this.hour,
      required this.minute,required this.type});

  ScheduleModel.fromJson(Map<String, dynamic> json) {
    subject = json['subject'];
    month = json['month'];
    day = json['day'];
    hour = json['hour'];
    minute = json['minute'];
    type = json['type'];
  }

  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'month': month,
      'day': day,
      'hour': hour,
      'minute': minute,
      'type': type,
    };
  }
}
