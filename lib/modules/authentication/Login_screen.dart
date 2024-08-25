import 'package:flutter/material.dart';
import 'package:mr_mm/modules/authentication/reset_password/send_reset_password_screen.dart';
import 'package:mr_mm/modules/authentication/signup_screen.dart';
import 'package:mr_mm/modules/home_screen.dart';
import 'package:mr_mm/shared/cache_helper.dart';
import 'package:mr_mm/shared/components.dart';
import 'package:mr_mm/shared/constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import '../../cubit/cubit.dart';
import '../../cubit/states.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AuthenticationLoginSuccessState) {
          CacheHelper.saveData(key: 'uId', value: state.uId)!.then((value) {
            showToast(text: 'Log in successfully!', state: ToastStates.SUCCESS);
            navigateAndFinish(context, const HomeScreen());
            return;
          }).catchError((error) {
            showToast(text: 'Log in failed!', state: ToastStates.ERROR);
            return;
          });
        } else if (state is AuthenticationEmailNotVerifiedErrorState) {
          showToast(
              text: 'Please, verify your email!', state: ToastStates.WARNING);
          return;
        } else if (state is AuthenticationLoginErrorState) {
          if (state.error.contains('incorrect')) {
            showToast(
                text: 'Email or password incorrect!', state: ToastStates.ERROR);
            return;
          } else {
            showToast(text: 'Something went wrong!', state: ToastStates.ERROR);
            return;
          }
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
                        width: (screenWidth / 1.5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Log in',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: theme.unselectedWidgetColor),
                            ),
                            const SizedBox(
                              height: 50.0,
                            ),
                            Text(
                              'Email',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: theme.unselectedWidgetColor),
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
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: theme.unselectedWidgetColor),
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
                                  cubit.userLogin(
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
                                condition:
                                    state is! AuthenticationLoginLoadingState &&
                                        state is! AppGetUserDataLoadingState,
                                builder: (BuildContext context) => Text(
                                  'Log in',
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 40.0,
                                  child: TextButton(
                                      onPressed: () {
                                        navigateTo(
                                            context, SendResetPasswordScreen());
                                      },
                                      child: const Text(
                                        'Forget password?',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange),
                                      )),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Don\'t have an account yet?',
                                  style: TextStyle(
                                      color: theme.unselectedWidgetColor),
                                ),
                                SizedBox(
                                  height: 40.0,
                                  child: TextButton(
                                      onPressed: () {
                                        navigateTo(context, SignUpScreen());
                                      },
                                      child: const Text(
                                        'Sign up',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange),
                                      )),
                                ),
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
