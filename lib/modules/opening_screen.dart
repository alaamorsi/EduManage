import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mr_mm/cubit/cubit.dart';
import 'package:mr_mm/cubit/states.dart';
import 'package:mr_mm/modules/authentication/Login_screen.dart';
import 'package:mr_mm/modules/home_screen.dart';
import 'package:mr_mm/shared/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_mm/shared/constant.dart';

class OpeningScreen extends StatefulWidget {
  const OpeningScreen({super.key});

  @override
  State<OpeningScreen> createState() => _OpeningScreenState();
}

class _OpeningScreenState extends State<OpeningScreen> {
  double logoOpacity = 0;
  double scale = 0.8;
  double t1 = 100;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 50), () {
      setState(() {
        logoOpacity = 1;
        scale = 1;
      });
    });
    Future.delayed(const Duration(seconds: 6)).then((value) async {
      if (uId != null && uId != '') {
        await AppCubit.get(context).getUserData();
        navigateAndFinish(context, const HomeScreen());
      } else {
        navigateTo(context, LoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: theme.primaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedOpacity(
                  duration: const Duration(seconds: 1),
                  opacity: logoOpacity,
                  child: AnimatedScale(
                    scale: scale,
                    duration: const Duration(seconds: 1),
                    child: const Image(
                      image: AssetImage("assets/images/opening-removebg.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                AnimatedSlide(
                  duration: const Duration(seconds: 2),
                  curve: Curves.bounceOut,
                  offset: Offset(0, t1 / 100),
                  onEnd: () {
                    setState(() {
                      t1 = 0;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.orange,
                              offset: Offset(-3, 6),
                              spreadRadius: 3,
                              blurRadius: 3),
                        ],
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fact_check_outlined,
                              size: 45.0,
                              color: Colors.orange,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              'EduManage',
                              style: TextStyle(
                                  color: theme.unselectedWidgetColor,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
