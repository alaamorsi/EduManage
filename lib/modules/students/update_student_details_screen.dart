import 'package:flutter/material.dart';
import 'package:mr_mm/cubit/cubit.dart';
import 'package:mr_mm/model/student_model.dart';
import 'package:mr_mm/modules/students/student_details_screen.dart';
import 'package:mr_mm/shared/components.dart';
import 'package:mr_mm/shared/constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/states.dart';

class UpdateStudentDetailsScreen extends StatelessWidget {
  TextEditingController examController = TextEditingController();
  TextEditingController degreeController = TextEditingController();
  TextEditingController maxDegreeController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  final StudentModel model;
  final String sExam;
  final String exam;
  final String degree;
  final String maxDegree;

  UpdateStudentDetailsScreen(
      {super.key,
      required this.model,
      required this.sExam,
      required this.exam,
      required this.degree,
      required this.maxDegree});

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    ThemeData theme = Theme.of(context);
    examController.text = exam;
    degreeController.text = degree;
    maxDegreeController.text = maxDegree;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is UpdateStudentDetailsSuccessState) {
          showToast(text: 'Updated successfully!', state: ToastStates.SUCCESS);
          return;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: defaultAppBar(theme, context, () {
            cubit.getStudentDetails(studentName: model.name);
            navigateTo(context, StudentDetailsScreen(model: model));
          }),
          body: WillPopScope(
            onWillPop: () async {
              cubit.getStudentDetails(studentName: model.name);
              navigateTo(context, StudentDetailsScreen(model: model));
              return true;
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: theme.primaryColor,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: screenWidth / 2,
                          height: screenWidth / 2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              image: const DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  'https://media.istockphoto.com/vectors/student-avatar-flat-icon-flat-vector-illustration-symbol-design-vector-id1212812078?k=20&m=1212812078&s=170667a&w=0&h=Pl6TaYY87D2nWwRSWmdtJJ0DKeD5vPowomY9fyeqNOs=',
                                ),
                              )),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              model.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: theme.unselectedWidgetColor),
                            ),
                            Text(
                              model.stage,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: theme.unselectedWidgetColor
                                      .withOpacity(0.5)),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            width: double.infinity,
                            height: 2.0,
                            color: theme.unselectedWidgetColor,
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: defaultTextFormField(
                            theme: theme,
                            formName: 'Exam name',
                            controller: examController,
                            onValidate: (String? value) {
                              if (value!.isEmpty) return 'Exam can\'t be empty';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: defaultTextFormField(
                            theme: theme,
                            formName: 'Student degree',
                            controller: degreeController,
                            type: TextInputType.number,
                            onValidate: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Student degree can\'t be empty';
                              } else {
                                double degree = double.tryParse(value) ?? 0.0;
                                double maxDegree =
                                    double.tryParse(maxDegreeController.text) ??
                                        0.0;
                                if (degree > maxDegree) {
                                  return 'Degree can\'t be greater than max degree';
                                }
                              }
                              return null; // Return null if there are no errors
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: defaultTextFormField(
                            theme: theme,
                            formName: 'Max degree',
                            controller: maxDegreeController,
                            type: TextInputType.number,
                            onValidate: (String? value) {
                              if (value!.isEmpty) {
                                return 'Max degree can\'t be empty';
                                return null;
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              cubit.updateStudentDetails(
                                  studentName: model.name,
                                  sExam: sExam,
                                  exam: examController.text,
                                  degree: double.parse(degreeController.text),
                                  maxDegree:
                                      double.parse(maxDegreeController.text));
                            }
                          },
                          style: ButtonStyle(
                            elevation: WidgetStateProperty.all(10.0),
                            backgroundColor:
                                WidgetStateProperty.all(Colors.orange),
                          ),
                          child: (state is! UpdateStudentDetailsLoadingState)
                              ? Text(
                                  'Update',
                                  style: TextStyle(
                                      fontSize: 21.0,
                                      color: theme.primaryColor,
                                      fontWeight: FontWeight.bold),
                                )
                              : CircularProgressIndicator(
                                  color: theme.primaryColor,
                                ),
                        )
                      ]),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
