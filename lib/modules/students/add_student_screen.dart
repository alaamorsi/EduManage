import 'package:flutter/material.dart';
import 'package:mr_mm/modules/students/student_screen.dart';
import 'package:mr_mm/shared/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/cubit.dart';
import '../../cubit/states.dart';

class AddStudentScreen extends StatelessWidget {
  AddStudentScreen({super.key});

  TextEditingController nameController = TextEditingController();
  TextEditingController stageController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    ThemeData theme = Theme.of(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AddStudentSuccessState) {
          showToast(text: 'Added successfully!', state: ToastStates.SUCCESS);
          nameController.clear();
          stageController.clear();
          return;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: defaultAppBar(theme, context, () {
            cubit.getStudents();
            navigateTo(context, StudentScreen());
          }),
          body: WillPopScope(
            onWillPop: () async {
              navigateTo(context, StudentScreen());
              cubit.getStudents();
              return true;
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: theme.primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Text(
                        'Add a new student',
                        style: TextStyle(
                            color: theme.unselectedWidgetColor,
                            fontSize: 21.0,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      defaultTextFormField(
                        theme: theme,
                          formName: 'Name',
                          controller: nameController,
                          onValidate: (String? value) {
                            if (value!.isEmpty) {
                              return 'Student name can\'t be empty';
                            }
                          }),
                      const SizedBox(
                        height: 20.0,
                      ),
                      defaultDropdownFormField(
                          theme: theme,
                          formName: 'Stage',
                          controller: stageController,
                          list: [
                            'Primary stage',
                            'Middle stage',
                            'Secondary stage'
                          ]),
                      const SizedBox(
                        height: 50.0,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            cubit.addStudent(
                                name: nameController.text,
                                stage: stageController.text);
                          }
                        },
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(10.0),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.orange),
                        ),
                        child: (state is! AddStudentLoadingState)
                            ? Text(
                                'Add',
                                style: TextStyle(
                                    fontSize: 21.0,
                                    color: theme.primaryColor,
                                    fontWeight: FontWeight.bold),
                              )
                            : CircularProgressIndicator(
                                color: theme.primaryColor,
                              ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
