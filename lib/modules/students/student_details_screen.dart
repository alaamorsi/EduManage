import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_mm/cubit/cubit.dart';
import 'package:mr_mm/cubit/states.dart';
import 'package:mr_mm/modules/students/add_student_details_screen.dart';
import 'package:mr_mm/modules/students/student_screen.dart';
import 'package:mr_mm/modules/students/update_student_details_screen.dart';

import '../../model/student_model.dart';
import '../../shared/components.dart';
import '../../shared/constant.dart';

class StudentDetailsScreen extends StatelessWidget {
  final StudentModel model;

  const StudentDetailsScreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    ThemeData theme = Theme.of(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: defaultAppBar(theme, context, () {
            navigateTo(context, StudentScreen());
          }),
          body: WillPopScope(
            onWillPop: () async {
              navigateTo(context, StudentScreen());
              return true;
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: theme.primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                            color:
                                theme.unselectedWidgetColor.withOpacity(0.5)),
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
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) =>
                            buildStudentDetailsItem(
                                cubit.studentDetailsList[index],
                                theme,
                                context),
                        separatorBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            width: double.infinity,
                            height: 1.0,
                            color: theme.unselectedWidgetColor,
                          ),
                        ),
                        itemCount: cubit.studentDetailsList.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: defaultFloatingActionButton(
              'Add student exams', context, theme, () {
            navigateTo(context, AddStudentDetailsScreen(model: model));
          }),
        );
      },
    );
  }

  Widget buildStudentDetailsItem(StudentDetailsModel item, ThemeData theme, context) {
    Color degreeColor = theme.unselectedWidgetColor;
    if (item.degree == item.maxDegree) {
      degreeColor = Colors.green;
    } else if (item.degree < item.maxDegree / 2) {
      degreeColor = Colors.red.shade600;
    }
    return InkWell(
      onTap: () {
        navigateTo(
            context,
            UpdateStudentDetailsScreen(
                model: model,
                sExam: item.exam,
                exam: item.exam,
                degree: item.degree.toString(),
                maxDegree: item.maxDegree.toString()));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.exam.toString(),
                  style: TextStyle(
                      fontSize: 21.0,
                      fontWeight: FontWeight.bold,
                      color: theme.unselectedWidgetColor),
                ),
                const Spacer(),
                Text(
                  item.degree.toString(),
                  style: TextStyle(
                      fontSize: 21.0,
                      fontWeight: FontWeight.bold,
                      color: degreeColor),
                ),
                Text('/',
                    style: TextStyle(
                        fontSize: 21.0,
                        fontWeight: FontWeight.bold,
                        color: theme.unselectedWidgetColor)),
                Text(
                  item.maxDegree.toString(),
                  style: TextStyle(
                      fontSize: 21.0,
                      fontWeight: FontWeight.bold,
                      color: theme.unselectedWidgetColor),
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
