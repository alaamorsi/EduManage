import 'package:flutter/material.dart';
import 'package:mr_mm/modules/home_screen.dart';
import 'package:mr_mm/modules/students/add_student_screen.dart';
import 'package:mr_mm/modules/students/student_details_screen.dart';
import 'package:mr_mm/shared/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/cubit.dart';
import '../../cubit/states.dart';

class StudentScreen extends StatelessWidget {
  TextEditingController searchController = TextEditingController();

  StudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ThemeData theme = Theme.of(context);
        return Scaffold(
          appBar: defaultAppBar(theme, context, () {
            navigateAndFinish(context, const HomeScreen());
          }),
          body: WillPopScope(
            onWillPop: () async {
              navigateAndFinish(context, const HomeScreen());
              return true;
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: theme.primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                cubit.searchStudentByName(
                                    searchName: searchController.text);
                              },
                              icon: const Icon(
                                Icons.search,
                                size: 30.0,
                                color: Colors.orange,
                              )),
                          Expanded(
                            child: TextFormField(
                              textInputAction: TextInputAction.search,
                              controller: searchController,
                              cursorColor: Colors.orange,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return null;
                                }
                                return null;
                              },
                              onChanged: (String? value) {},
                              onFieldSubmitted: (String? value) {
                                if (value!.isNotEmpty) {
                                  cubit.searchStudentByName(
                                      searchName: searchController.text);
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Search',
                                hintText: 'Search',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                filled: true,
                                fillColor: Colors.grey[250],
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.orange, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                            ),
                          ),
                          SizedBox(width: 5.0,),
                          Text('Students: ${cubit.studentList.length}',style: TextStyle(fontSize: 14.0,color: theme.unselectedWidgetColor),),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 1.0,
                      color: theme.unselectedWidgetColor,
                    ),
                    if (state is GetStudentsLoadingState ||
                        state is SearchStudentLoadingState)
                      const Expanded(
                          child: Center(
                              child: CircularProgressIndicator(
                        color: Colors.orange,
                      ))),
                    state is GetStudentsEmptyState ? Expanded(child: Center(child: Text('No students found',style: TextStyle(color: theme.unselectedWidgetColor.withOpacity(0.8),fontSize: 18.0),),)) : Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => buildStudentItem(
                                cubit.studentList.reversed.toList()[index],
                                context,
                                theme),
                            separatorBuilder: (context, index) => Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: theme.unselectedWidgetColor,
                                ),
                            itemCount: cubit.studentList.length),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: defaultFloatingActionButton('Add a new student',context, theme, () {
            navigateTo(context, AddStudentScreen());
          }),
        );
      },
    );
  }
}

Widget buildStudentItem(list, context, ThemeData theme) {
  return InkWell(
    onTap: () async {
      await AppCubit.get(context).getStudentDetails(studentName: list.name);
      navigateTo(
          context,
          StudentDetailsScreen(
            model: list,
          ));
    },
    child: Column(
      children: [
        const SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 70.0,
              height: 70.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      'https://media.istockphoto.com/vectors/student-avatar-flat-icon-flat-vector-illustration-symbol-design-vector-id1212812078?k=20&m=1212812078&s=170667a&w=0&h=Pl6TaYY87D2nWwRSWmdtJJ0DKeD5vPowomY9fyeqNOs=',
                    ),
                  )),
            ),
            const SizedBox(
              width: 5.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  list.name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: theme.unselectedWidgetColor),
                ),
                Text(
                  list.stage,
                  style: TextStyle(
                      fontSize: 12.0,
                      color: theme.unselectedWidgetColor.withOpacity(0.5)),
                ),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
      ],
    ),
  );
}
