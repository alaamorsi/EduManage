class UserDataModel {
  late String fName;
  late String lName;
  late String email;
  late String uId;
  late bool isEmailVerified;

  UserDataModel({
    required this.fName,
    required this.lName,
    required this.email,
    required this.uId,
    required this.isEmailVerified,
  });

  UserDataModel.fromJson(Map<String, dynamic> json) {
    fName = json['fName'];
    lName = json['lName'];
    email = json['email'];
    uId = json['uId'];
    isEmailVerified = json['isEmailVerified'];
  }

  Map<String, dynamic> toMap() {
    return {
      'fName': fName,
      'lName': lName,
      'email': email,
      'uId': uId,
      'isEmailVerified': isEmailVerified,
    };
  }
}
