import 'package:flutter/material.dart';
import 'package:mr_mm/modules/notes/notes_screen.dart';
import 'package:mr_mm/modules/schedule/schedule_screen.dart';
import 'package:mr_mm/modules/settings/settings_screen.dart';
import 'package:mr_mm/modules/students/student_screen.dart';
import 'package:mr_mm/shared/components.dart';
import 'package:mr_mm/shared/constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import 'files/files_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _reloadUser() async {
    await FirebaseAuth.instance.currentUser!.reload();
    if (FirebaseAuth.instance.currentUser!.emailVerified)
      await AppCubit.get(context).getUserData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        ThemeData theme = Theme.of(context);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: theme.primaryColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.fact_check_outlined,
                  size: 34.0,
                  color: Colors.orange,
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  'EduManage',
                  style: TextStyle(
                      color: theme.unselectedWidgetColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0),
                ),
              ],
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    navigateTo(context, const SettingsScreen());
                  },
                  icon: const Icon(
                    Icons.settings,
                    size: 35.0,
                    color: Colors.orange,
                  ))
            ],
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: theme.primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Welcome : ',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: theme.unselectedWidgetColor,
                        ),
                      ),
                      Text(
                        cubit.model?.fName ?? '',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: double.infinity,
                    height: 1.0,
                    color: theme.unselectedWidgetColor,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                navigateTo(context, StudentScreen());
                                cubit.getStudents();
                              },
                              child: Container(
                                width: screenWidth / 2 - 20,
                                height: screenWidth / 2,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: theme.unselectedWidgetColor.withOpacity(0.7),
                                    width: 3.0,
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.orange.shade100,
                                      Colors.orange.shade400,
                                    ],
                                  ),
                                  borderRadius:
                                  BorderRadius.circular(25.0),
                                ),
                                child: const Column(
                                  children: [
                                    Expanded(
                                      child: Image(
                                        image: AssetImage(
                                            'assets/images/students (1).png'),
                                      ),
                                    ),
                                    Text(
                                      'Students',
                                      style: TextStyle(
                                        fontSize: 21.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: 1.0,
                              height: screenWidth / 2,
                              color: theme.unselectedWidgetColor,
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                navigateTo(context, ScheduleScreen());
                                cubit.getSchedules();
                              },
                              child: Container(
                                width: screenWidth / 2 - 20,
                                height: screenWidth / 2,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: theme.unselectedWidgetColor.withOpacity(0.7),
                                    width: 3.0,
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.orange.shade100,
                                      Colors.orange.shade400,
                                    ],
                                  ),
                                  borderRadius:
                                  BorderRadius.circular(25.0),
                                ),
                                child: const Column(
                                  children: [
                                    Expanded(
                                      child: Image(
                                        image: AssetImage(
                                            'assets/images/calendar.png'),
                                      ),
                                    ),
                                    Text(
                                      'Schedule',
                                      style: TextStyle(
                                        fontSize: 21.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0,),
                        Container(
                          width: screenWidth / 2 - 20,
                          height: 1.0,
                          color: theme.unselectedWidgetColor,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: screenWidth / 2 - 20,
                              height: 1.0,
                              color: theme.unselectedWidgetColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0,),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                navigateTo(
                                    context, const FilesScreen());
                              },
                              child: Container(
                                width: screenWidth / 2 - 20,
                                height: screenWidth / 2,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: theme.unselectedWidgetColor.withOpacity(0.7),
                                    width: 3.0,
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.orange.shade100,
                                      Colors.orange.shade400,
                                    ],
                                  ),
                                  borderRadius:
                                  BorderRadius.circular(25.0),
                                ),
                                child: const Column(
                                  children: [
                                    Expanded(
                                      child: Image(
                                        image: AssetImage(
                                            'assets/images/folder.png'),
                                      ),
                                    ),
                                    Text(
                                      'Files',
                                      style: TextStyle(
                                        fontSize: 21.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: 1.0,
                              height: screenWidth / 2,
                              color: theme.unselectedWidgetColor,
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: (){
                                navigateTo(context, const NotesScreen());
                                cubit.getNotes();
                              },
                              child: Container(
                                width: screenWidth / 2 - 20,
                                height: screenWidth / 2,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: theme.unselectedWidgetColor.withOpacity(0.7),
                                    width: 3.0,
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.orange.shade100,
                                      Colors.orange.shade400,
                                    ],
                                  ),
                                  borderRadius:
                                  BorderRadius.circular(25.0),
                                ),
                                child: const Column(
                                  children: [
                                    Expanded(
                                      child: Image(
                                        image: AssetImage(
                                            'assets/images/pencil.png'),
                                      ),
                                    ),
                                    Text(
                                      'Notes',
                                      style: TextStyle(
                                        fontSize: 21.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
