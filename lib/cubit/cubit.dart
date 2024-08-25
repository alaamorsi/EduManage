import 'package:flutter/material.dart';
import 'package:mr_mm/cubit/states.dart';
import 'package:mr_mm/model/note_model.dart';
import 'package:mr_mm/model/schedule_model.dart';
import 'package:mr_mm/model/student_model.dart';
import 'package:mr_mm/model/user_data_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mr_mm/shared/cache_helper.dart';
import 'package:mr_mm/shared/constant.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(AuthenticationChangePasswordVisibilityState());
  }

  void resetState() {
    emit(AppInitialState());
  }

  // Register
  void userRegister({
    required String fName,
    required String lName,
    required String email,
    required String password,
  }) {
    emit(AuthenticationSignUpLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      userCreate(
          fName: fName,
          lName: lName,
          email: email,
          password: password,
          uId: value.user!.uid);
    }).catchError((error) {
      print(error);
      emit(AuthenticationSignUpErrorState());
    });
  }

  // Create user
  void userCreate({
    required String fName,
    required String lName,
    required String email,
    required String password,
    required String uId,
  }) {
    UserDataModel userDataModel = UserDataModel(
        fName: fName,
        lName: lName,
        email: email,
        uId: uId,
        isEmailVerified: false);
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(userDataModel.toMap())
        .then((value) {
      emit(AuthenticationCreateUserSuccessState());
    }).catchError((error) {
      print(error);
      emit(AuthenticationCreateUserErrorState());
    });
  }

  // Log in
  void userLogin({
    required String email,
    required String password,
  }) {
    emit(AuthenticationLoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        CacheHelper.saveData(key: 'uId', value: value.user!.uid);
        uId = value.user!.uid;
        await getUserData();
        emit(AuthenticationLoginSuccessState(value.user!.uid));
      } else {
        emit(AuthenticationEmailNotVerifiedErrorState());
      }
    }).catchError((error) {
      emit(AuthenticationLoginErrorState(error.toString()));
    });
  }

  //Send password reset code
  Future<void> sendPasswordResetEmail(String email) async {
    emit(AuthenticationSendResetPasswordLoadingState());
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      print('Password reset email sent');
      emit(AuthenticationSendResetPasswordSuccessState());
    } catch (e) {
      print('Failed to send password reset email: $e');
      emit(AuthenticationSendResetPasswordErrorState());
    }
  }

  //Verify password reset code
  Future<void> verifyPasswordResetCode(String code) async {
    emit(AuthenticationVerifyPasswordCodeLoadingState());
    try {
      String email = await FirebaseAuth.instance.verifyPasswordResetCode(code);
      print('Code verified for email: $email');
      emit(AuthenticationVerifyPasswordCodeSuccessState());
    } catch (e) {
      print('Failed to verify reset code: $e');
      emit(AuthenticationVerifyPasswordCodeErrorState());
    }
  }

  //Confirm password reset
  Future<void> confirmPasswordReset(String code, String newPassword) async {
    emit(AuthenticationConfirmPasswordResetLoadingState());
    try {
      await FirebaseAuth.instance.confirmPasswordReset(
        code: code,
        newPassword: newPassword,
      );
      print('Password has been reset');
      emit(AuthenticationConfirmPasswordResetSuccessState());
    } catch (e) {
      print('Failed to reset password: $e');
      emit(AuthenticationConfirmPasswordResetErrorState());
    }
  }

  //Log out
  void userLogOut() {
    emit(AuthenticationLogOutLoadingState());
    FirebaseAuth.instance.signOut().then((value) {
      Future.delayed(const Duration(seconds: 2)).then((value) {
        CacheHelper.removeData(key: 'uId');
        uId = '';
        emit(AuthenticationLogOutSuccessState());
      });
    }).catchError((error) {
      emit(AuthenticationLogOutErrorState());
    });
  }

  // Get User Data
  UserDataModel? model;

  Future<void> getUserData() async {
    emit(AppGetUserDataLoadingState());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
      model = UserDataModel.fromJson(value.data()!);
      print(model!.fName);
      emit(AppGetUserDataSuccessState());
    }).catchError((error) {
      print(error);
      emit(AppGetUserDataErrorState());
    });
  }

  // Add student
  void addStudent({
    required String name,
    required String stage,
  }) {
    emit(AddStudentLoadingState());
    StudentModel studentModel = StudentModel(name: name, stage: stage);

    FirebaseFirestore.instance.collection('users').doc(uId).update({
      'students': FieldValue.arrayUnion([studentModel.toMap()]),
    }).then((value) {
      emit(AddStudentSuccessState());
    }).catchError((error) {
      print(error);
      emit(AddStudentErrorState());
    });
  }

  //Get student
  List<StudentModel> studentList = [];

  Future<void> getStudents() async {
    studentList = [];
    emit(GetStudentsLoadingState());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
      if (value.exists) {
        List<dynamic> students = value.get('students');
        studentList =
            students.map((student) => StudentModel.fromJson(student)).toList();
        if (studentList.isEmpty) {
          emit(GetStudentsEmptyState());
        } else {
          emit(GetStudentsSuccessState());
        }
      } else {
        emit(GetStudentsEmptyState());
      }
    }).catchError((error) {
      print(error);
      emit(GetStudentsErrorState());
    });
  }

  //Search about student name
  List<StudentModel> searchList = [];

  void searchStudentByName({
    required String searchName,
  }) {
    searchList = [];
    studentList = [];
    emit(SearchStudentLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      if (value.exists) {
        List<dynamic> students = value.get('students');
        List<StudentModel> studentModel =
            students.map((student) => StudentModel.fromJson(student)).toList();

        // Filter the list based on the student's name
        searchList = studentModel
            .where((student) =>
                student.name.toLowerCase().contains(searchName.toLowerCase()))
            .toList();
        studentList = searchList;

        if (studentList.isEmpty) {
          emit(SearchStudentEmptyState());
        } else {
          emit(SearchStudentSuccessState());
        }
      } else {
        emit(SearchStudentEmptyState());
      }
    }).catchError((error) {
      print(error);
      emit(SearchStudentErrorState());
    });
  }

  // Add Student Details
  void addStudentDetails({
    required String studentName,
    required String exam,
    required double degree,
    required double maxDegree,
  }) {
    emit(AddStudentDetailsLoadingState());

    StudentDetailsModel model =
        StudentDetailsModel(exam: exam, degree: degree, maxDegree: maxDegree);

    FirebaseFirestore.instance.collection('users').doc(uId).get().then((doc) {
      if (doc.exists) {
        List students = doc['students'];
        for (var student in students) {
          if (student['name'] == studentName) {
            if (student['details'] == null) {
              student['details'] = [];
            }
            student['details'].add(model.toMap());
            break;
          }
        }

        FirebaseFirestore.instance.collection('users').doc(uId).update({
          'students': students,
        }).then((value) {
          emit(AddStudentDetailsSuccessState());
        }).catchError((error) {
          print(error);
          emit(AddStudentDetailsErrorState());
        });
      }
    }).catchError((error) {
      print(error);
      emit(AddStudentDetailsErrorState());
    });
  }

  // Get student details
  List<StudentDetailsModel> studentDetailsList = [];

  Future<void> getStudentDetails({
    required String studentName,
  }) async {
    studentDetailsList = [];
    emit(GetStudentsDetailsLoadingState());

    FirebaseFirestore.instance.collection('users').doc(uId).get().then((doc) {
      if (doc.exists) {
        List students = doc['students'];
        for (var student in students) {
          if (student['name'] == studentName) {
            List details = student['details'] ?? [];
            studentDetailsList = details
                .map((detail) => StudentDetailsModel.fromJson(detail))
                .toList();
            break;
          }
        }
        if (studentDetailsList.isEmpty) {
          emit(GetStudentsDetailsSuccessState());
        } else {
          emit(GetStudentsDetailsEmptyState());
        }
      }
    }).catchError((error) {
      print(error);
      emit(GetStudentsDetailsErrorState());
    });
  }

  //Update student details
  Future<void> updateStudentDetails({
    required String studentName, // Student name to search by
    required String sExam, // Exam name to search by
    required String exam, // New exam name
    required double degree, // New degree
    required double maxDegree, // New max degree
  }) async {
    emit(UpdateStudentDetailsLoadingState());

    try {
      // Retrieve the user's document
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uId).get();

      if (userDoc.exists) {
        List<dynamic> students = userDoc.get('students');

        // Find the student with the matching name
        Map<String, dynamic>? studentToUpdate;
        for (var student in students) {
          if (student['name'] == studentName) {
            studentToUpdate = Map<String, dynamic>.from(student);
            break; // Stop the loop after finding the first match
          }
        }

        if (studentToUpdate != null) {
          // Check if the student has existing details
          if (studentToUpdate['details'] == null) {
            studentToUpdate['details'] = [];
          }

          // Update the student's details
          List<dynamic> details = studentToUpdate['details'];
          bool updated = false;

          for (var detail in details) {
            if (detail['exam'] == sExam) {
              detail['exam'] = exam;
              detail['degree'] = degree;
              detail['maxDegree'] = maxDegree;
              updated = true;
              break; // Update only the first matching exam
            }
          }

          if (!updated) {
            // If the exam was not found, add it as a new detail
            details.add({
              'exam': exam,
              'degree': degree,
              'maxDegree': maxDegree,
            });
          }

          // Update the student's data in the Firestore document
          await FirebaseFirestore.instance.collection('users').doc(uId).update({
            'students': students,
          });

          emit(UpdateStudentDetailsSuccessState());
        } else {
          print('Student not found');
          emit(UpdateStudentDetailsErrorState());
        }
      } else {
        print('User document not found');
        emit(UpdateStudentDetailsErrorState());
      }
    } catch (error) {
      print(error);
      emit(UpdateStudentDetailsErrorState());
    }
  }

  // Add schedule
  void addSchedule({
    required String subject,
    required String month,
    required String day,
    required int hour,
    required int minute,
    required String type,
  }) {
    emit(AddScheduleLoadingState());
    ScheduleModel scheduleModel = ScheduleModel(
        subject: subject,
        month: month,
        day: day,
        hour: hour,
        minute: minute,
        type: type);
    FirebaseFirestore.instance.collection('users').doc(uId).update({
      'schedules': FieldValue.arrayUnion([scheduleModel.toMap()]),
    }).then((value) {
      emit(AddScheduleSuccessState());
    }).catchError((error) {
      print(error);
      emit(AddScheduleErrorState());
    });
  }

  //Get schedules
  List<ScheduleModel> scheduleList = [];

  Future<void> getSchedules() async {
    scheduleList = [];
    emit(GetSchedulesLoadingState());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
      if (value.exists) {
        List<dynamic> schedules = value.get('schedules');
        scheduleList = schedules
            .map((schedule) => ScheduleModel.fromJson(schedule))
            .toList();
        if (scheduleList.isEmpty) {
          emit(GetSchedulesEmptyState());
        } else {
          emit(GetSchedulesSuccessState());
        }
      }
    }).catchError((error) {
      print(error);
      emit(GetSchedulesErrorState());
    });
  }

  //Update schedule
  Future<void> updateSchedule({
    required String sSubject, // subject to search by
    required String nSubject, // New subject
    required String nMonth, // New month
    required String nDay, // New day
    required int nHour, // New hour
    required int nMinute, // New minute
    required String nType, // New type
  }) async {
    emit(UpdateScheduleLoadingState());

    try {
      // Retrieve the user's notes
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uId).get();
      List<dynamic> schedules = userDoc.get('schedules');

      // Find the note with the matching title
      Map<String, dynamic>? oldSchedule;
      for (var schedule in schedules) {
        if (schedule['subject'] == sSubject) {
          oldSchedule = Map<String, dynamic>.from(schedule);
          break;
        }
      }

      if (oldSchedule != null) {
        // Remove the old note
        await FirebaseFirestore.instance.collection('users').doc(uId).update({
          'schedules': FieldValue.arrayRemove([oldSchedule]),
        });

        // Add the updated note
        ScheduleModel updatedSchedule = ScheduleModel(
          subject: nSubject,
          month: nMonth,
          day: nDay,
          hour: nHour,
          minute: nMinute,
          type: nType,
        );
        await FirebaseFirestore.instance.collection('users').doc(uId).update({
          'schedules': FieldValue.arrayUnion([updatedSchedule.toMap()]),
        });

        emit(UpdateScheduleSuccessState());
      } else {
        print('Schedule not found');
        emit(UpdateScheduleErrorState());
      }
    } catch (error) {
      print(error);
      emit(UpdateScheduleErrorState());
    }
  }

  //Add note
  void addNote({
    required String title,
    required String body,
    required String time,
  }) {
    emit(AddNoteLoadingState());
    NoteModel noteModel = NoteModel(
      title: title,
      body: body,
      time: time,
    );
    FirebaseFirestore.instance.collection('users').doc(uId).update({
      'notes': FieldValue.arrayUnion([noteModel.toMap()]),
    }).then((value) {
      emit(AddNoteSuccessState());
    }).catchError((error) {
      print(error);
      emit(AddNoteErrorState());
    });
  }

  Future<void> updateNote({
    required String sTitle, // Title to search by
    required String title, // New title
    required String body, // New body
    required String time, // New time
  }) async {
    emit(UpdateNoteLoadingState());

    try {
      // Retrieve the user's notes
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uId).get();
      List<dynamic> notes = userDoc.get('notes');

      // Find the note with the matching title
      Map<String, dynamic>? oldNote;
      for (var note in notes) {
        if (note['title'] == sTitle) {
          oldNote = Map<String, dynamic>.from(note);
          break;
        }
      }

      if (oldNote != null) {
        // Remove the old note
        await FirebaseFirestore.instance.collection('users').doc(uId).update({
          'notes': FieldValue.arrayRemove([oldNote]),
        });

        // Add the updated note
        NoteModel updatedNote = NoteModel(
          title: title,
          body: body,
          time: time,
        );
        await FirebaseFirestore.instance.collection('users').doc(uId).update({
          'notes': FieldValue.arrayUnion([updatedNote.toMap()]),
        });

        emit(UpdateNoteSuccessState());
      } else {
        print('Note not found');
        emit(UpdateNoteErrorState());
      }
    } catch (error) {
      print(error);
      emit(UpdateNoteErrorState());
    }
  }

  //Get notes
  List<NoteModel> notesList = [];

  Future<void> getNotes() async {
    notesList = [];
    emit(GetNotesLoadingState());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
      if (value.exists) {
        List<dynamic> notes = value.get('notes');
        notesList = notes.map((note) => NoteModel.fromJson(note)).toList();
        if (notesList.isEmpty) {
          emit(GetNotesEmptyState());
        } else {
          emit(GetNotesSuccessState());
        }
      }
    }).catchError((error) {
      print(error);
      emit(GetNotesErrorState());
    });
  }

  //Dark mode
  bool isDark = CacheHelper.getData(key: 'isDark') ?? false;

  changeMode(bool? mode) {
    if (mode != null) {
      isDark = mode;
      CacheHelper.saveData(key: 'isDark', value: isDark)!.then((value) {
        emit(ChangeAppMode());
      });
    }
  }
}
