import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_mm/modules/authentication/Login_screen.dart';
import 'package:mr_mm/modules/home_screen.dart';
import 'package:mr_mm/shared/components.dart';
import 'package:mr_mm/shared/constant.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import '../../cubit/cubit.dart';
import '../../cubit/states.dart';
import '../../shared/cache_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatelessWidget {
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AuthenticationCreateUserSuccessState) {
          FirebaseAuth.instance.currentUser!.sendEmailVerification();
          showToast(
              text: 'Sign up successfully,\nCheck box!',
              state: ToastStates.SUCCESS);
          navigateAndFinish(context, LoginScreen());
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        ThemeData theme = Theme.of(context);
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: theme.primaryColor,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 50.0, horizontal: 30.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.fact_check_outlined,
                            size: 34.0,
                            color: Colors.orange,
                          ),
                          const SizedBox(
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
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: (screenWidth / 1.5) ,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text(
                              'Sign up',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25,color: theme.unselectedWidgetColor),
                            ),
                            const SizedBox(
                              height: 50.0,
                            ),
                             Text(
                              'First name',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0,color: theme.unselectedWidgetColor),
                            ),
                            TextFormField(
                              controller: fNameController,
                              cursorColor: Colors.orange,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'First name can\'t be empty!';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'First name',
                                hintText: 'First name',
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
                            const SizedBox(
                              height: 20.0,
                            ),
                             Text(
                              'Last name',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0,color: theme.unselectedWidgetColor),
                            ),
                            TextFormField(
                              controller: lNameController,
                              cursorColor: Colors.orange,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Last name can\'t be empty!';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Last name',
                                hintText: 'Last name',
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
                            const SizedBox(
                              height: 20.0,
                            ),
                             Text(
                              'Email',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0,color: theme.unselectedWidgetColor),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              controller: emailController,
                              cursorColor: Colors.orange,
                              validator: (String? value) {
                                if (value!.isEmpty || value.length < 5) {
                                  return 'Invalid Email!';
                                }
                                else if (value.contains(' ')) {
                                  return 'Email can\'t contain space';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'Email',
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
                            const SizedBox(
                              height: 20.0,
                            ),
                             Text(
                              'Password',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0,color: theme.unselectedWidgetColor),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              controller: passwordController,
                              cursorColor: Colors.orange,
                              obscureText: cubit.isPassword,
                              validator: (String? value) {
                                if (value!.isEmpty || value.length < 6) {
                                  return 'Invalid Password!';
                                }
                                else if (value.contains(' ')) {
                                  return 'Password can\'t contain space';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Password',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    cubit.changePasswordVisibility();
                                  },
                                  icon: Icon(cubit.suffix),
                                ),
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
                            const SizedBox(
                              height: 20.0,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  cubit.userRegister(
                                      fName: fNameController.text,
                                      lName: lNameController.text,
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              },
                              style: ButtonStyle(
                                  fixedSize: WidgetStateProperty.all(
                                      Size.fromWidth(screenWidth)),
                                  backgroundColor:
                                      WidgetStateProperty.all(Colors.orange)),
                              child: ConditionalBuilder(
                                condition: state
                                        is! AuthenticationSignUpLoadingState &&
                                    state is! AppGetUserDataLoadingState,
                                builder: (BuildContext context) =>  Text(
                                  'Sign up',
                                  style: TextStyle(
                                      color: theme.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                                fallback: (BuildContext context) =>
                                     CircularProgressIndicator(
                                  color: theme.primaryColor,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                 Text('Already have an account?',style: TextStyle(color: theme.unselectedWidgetColor),),
                                TextButton(
                                    onPressed: () {
                                      navigateTo(context, LoginScreen());
                                    },
                                    child: const Text(
                                      'Log in',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
