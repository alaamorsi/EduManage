import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_mm/cubit/cubit.dart';
import 'package:mr_mm/cubit/states.dart';
import 'package:mr_mm/modules/authentication/reset_password/confirm_reset_password_screen.dart';
import 'package:mr_mm/modules/authentication/reset_password/send_reset_password_screen.dart';
import 'package:mr_mm/modules/authentication/reset_password/verify_reset_code_screen.dart';
import 'package:mr_mm/shared/components.dart';
import 'package:mr_mm/shared/constant.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

class VerifyResetCodeScreen extends StatelessWidget {
  TextEditingController codeController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  VerifyResetCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AuthenticationVerifyPasswordCodeSuccessState) {
          navigateTo(
              context, ConfirmResetPasswordScreen(code: codeController.text));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: defaultAppBar(theme, context, () {
            navigateTo(context, SendResetPasswordScreen());
          }),
          body: WillPopScope(
            onWillPop: () async {
              navigateTo(context, SendResetPasswordScreen());
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
                                'Forget password',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: theme.unselectedWidgetColor),
                              ),
                              Text(
                                  'Please enter the code that was sent to your email.',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: theme.unselectedWidgetColor
                                          .withOpacity(0.8))),
                              const SizedBox(
                                height: 30.0,
                              ),
                              Text(
                                'Reset code',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: theme.unselectedWidgetColor),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                controller: codeController,
                                cursorColor: Colors.orange,
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Can\'t be empty';
                                  }
                                  if (value.isNotEmpty) {
                                    if (state
                                        is AuthenticationVerifyPasswordCodeErrorState) {
                                      return 'Incorrect code!';
                                    }
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'code',
                                  hintText: 'code',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  filled: true,
                                  fillColor: Colors.grey[250],
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.orange, width: 2.0),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    await cubit.verifyPasswordResetCode(
                                        codeController.text);
                                  }
                                },
                                style: ButtonStyle(
                                    fixedSize: WidgetStateProperty.all(
                                        Size.fromWidth(screenWidth)),
                                    backgroundColor:
                                        WidgetStateProperty.all(Colors.orange)),
                                child: ConditionalBuilder(
                                  condition: state
                                      is! AuthenticationVerifyPasswordCodeLoadingState,
                                  builder: (BuildContext context) => Text(
                                    'Next',
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
                            ],
                          ),
                        ),
                      ),
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
