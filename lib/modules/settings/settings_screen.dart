import 'package:flutter/material.dart';
import 'package:mr_mm/cubit/cubit.dart';
import 'package:mr_mm/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_mm/modules/authentication/Login_screen.dart';
import 'package:mr_mm/modules/home_screen.dart';
import 'package:mr_mm/shared/components.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AuthenticationLogOutSuccessState) {
          navigateAndFinish(context, LoginScreen());
        }
      },
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
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      height: 60.0,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange, width: 2.0),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Dark mode',
                            style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: theme.unselectedWidgetColor),
                          ),
                          const Spacer(),
                          Switch(
                            activeColor: theme.primaryColor,
                            activeTrackColor: Colors.orange,
                            inactiveThumbColor: theme.unselectedWidgetColor,
                            inactiveTrackColor: theme.primaryColor,
                            value: AppCubit.get(context).isDark,
                            onChanged: (value) {
                              AppCubit.get(context).changeMode(value);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    InkWell(
                      onTap: () {
                        AppCubit.get(context).userLogOut();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        height: 60.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange, width: 2.0),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Log out',
                              style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: theme.unselectedWidgetColor),
                            ),
                            const Spacer(),
                            state is! AuthenticationLogOutLoadingState
                                ? const Icon(
                                    Icons.logout,
                                    size: 30.0,
                                    color: Colors.red,
                                  )
                                : const CircularProgressIndicator(
                                    color: Colors.red,
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
