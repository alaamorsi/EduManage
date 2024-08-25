abstract class AppStates {}

class AppInitialState extends AppStates {}

//login
class AuthenticationLoginLoadingState extends AppStates {}

class AuthenticationLoginSuccessState extends AppStates {
  final String uId;

  AuthenticationLoginSuccessState(this.uId);
}

class AuthenticationLoginErrorState extends AppStates {
  final String error;

  AuthenticationLoginErrorState(this.error);
}

class AuthenticationEmailNotVerifiedErrorState extends AppStates {}

//log out
class AuthenticationLogOutLoadingState extends AppStates {}

class AuthenticationLogOutSuccessState extends AppStates {}

class AuthenticationLogOutErrorState extends AppStates {}

//sign up
class AuthenticationSignUpLoadingState extends AppStates {}

class AuthenticationSignUpSuccessState extends AppStates {}

class AuthenticationSignUpErrorState extends AppStates {}

//create user
class AuthenticationCreateUserLoadingState extends AppStates {}

class AuthenticationCreateUserSuccessState extends AppStates {}

class AuthenticationCreateUserErrorState extends AppStates {}

//send reset password
class AuthenticationSendResetPasswordLoadingState extends AppStates {}

class AuthenticationSendResetPasswordSuccessState extends AppStates {}

class AuthenticationSendResetPasswordErrorState extends AppStates {}

//verify password reset code
class AuthenticationVerifyPasswordCodeLoadingState extends AppStates {}

class AuthenticationVerifyPasswordCodeSuccessState extends AppStates {}

class AuthenticationVerifyPasswordCodeErrorState extends AppStates {}

//confirm password reset
class AuthenticationConfirmPasswordResetLoadingState extends AppStates {}

class AuthenticationConfirmPasswordResetSuccessState extends AppStates {}

class AuthenticationConfirmPasswordResetErrorState extends AppStates {}

//get user data
class AppGetUserDataLoadingState extends AppStates {}

class AppGetUserDataSuccessState extends AppStates {}

class AppGetUserDataErrorState extends AppStates {}

// add student
class AddStudentLoadingState extends AppStates {}

class AddStudentSuccessState extends AppStates {}

class AddStudentErrorState extends AppStates {}

// add schedule
class AddScheduleLoadingState extends AppStates {}

class AddScheduleSuccessState extends AppStates {}

class AddScheduleErrorState extends AppStates {}

//update note
class UpdateScheduleLoadingState extends AppStates {}

class UpdateScheduleSuccessState extends AppStates {}

class UpdateScheduleErrorState extends AppStates {}

//add note
class AddNoteLoadingState extends AppStates {}

class AddNoteSuccessState extends AppStates {}

class AddNoteErrorState extends AppStates {}

//update note
class UpdateNoteLoadingState extends AppStates {}

class UpdateNoteSuccessState extends AppStates {}

class UpdateNoteErrorState extends AppStates {}

// add student details
class AddStudentDetailsLoadingState extends AppStates {}

class AddStudentDetailsSuccessState extends AppStates {}

class AddStudentDetailsErrorState extends AppStates {}

//update student details
class UpdateStudentDetailsLoadingState extends AppStates {}

class UpdateStudentDetailsSuccessState extends AppStates {}

class UpdateStudentDetailsErrorState extends AppStates {}

//get student
class GetStudentsLoadingState extends AppStates {}

class GetStudentsSuccessState extends AppStates {}

class GetStudentsErrorState extends AppStates {}

class GetStudentsEmptyState extends AppStates {}

//get schedule
class GetSchedulesLoadingState extends AppStates {}

class GetSchedulesSuccessState extends AppStates {}

class GetSchedulesErrorState extends AppStates {}

class GetSchedulesEmptyState extends AppStates {}

//get notes
class GetNotesLoadingState extends AppStates {}

class GetNotesSuccessState extends AppStates {}

class GetNotesErrorState extends AppStates {}

class GetNotesEmptyState extends AppStates {}

//get student
class GetStudentsDetailsLoadingState extends AppStates {}

class GetStudentsDetailsSuccessState extends AppStates {}

class GetStudentsDetailsErrorState extends AppStates {}

class GetStudentsDetailsEmptyState extends AppStates {}

//search about student
class SearchStudentLoadingState extends AppStates {}

class SearchStudentSuccessState extends AppStates {}

class SearchStudentErrorState extends AppStates {}

class SearchStudentEmptyState extends AppStates {}

//change eye password
class AuthenticationChangePasswordVisibilityState extends AppStates {}

class ChangeAppMode extends AppStates {}
