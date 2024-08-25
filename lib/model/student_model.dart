class StudentModel {
  late String name;
  late String stage;


  StudentModel({
    required this.name,
    required this.stage,
  });

  StudentModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    stage = json['stage'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'stage': stage,
    };
  }
}
class StudentDetailsModel{
  late String exam;
  late double degree;
  late double maxDegree;
  StudentDetailsModel({required this.exam,required this.degree,required this.maxDegree});
  StudentDetailsModel.fromJson(Map<String, dynamic> json) {
    exam = json['exam'];
    degree = json['degree'];
    maxDegree = json['maxDegree'];
  }

  Map<String, dynamic> toMap() {
    return {
      'exam': exam,
      'degree': degree,
      'maxDegree': maxDegree,
    };
  }
}