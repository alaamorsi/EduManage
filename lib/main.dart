import 'package:flutter/material.dart';
import 'package:mr_mm/cubit/states.dart';
import 'package:mr_mm/modules/opening_screen.dart';
import 'package:mr_mm/shared/app_theme.dart';
import 'package:mr_mm/shared/bloc_observer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_mm/shared/cache_helper.dart';
import 'package:mr_mm/shared/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'cubit/cubit.dart';
import 'firebase_options.dart';
import 'modules/authentication/Login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  Widget widget;
  uId = CacheHelper.getData(key: 'uId') ?? '';
  isDark = CacheHelper.getData(key: 'isDark') ?? false;
  if (uId != null) {
    widget = const OpeningScreen();
  } else {
    widget = LoginScreen();
  }

  runApp(MyApp(
    startWidget: widget,
    isDark: isDark,
  ));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  final bool? isDark;

  const MyApp({super.key, required this.startWidget, required this.isDark});

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return MultiBlocProvider(
        providers: [BlocProvider(create: (BuildContext context) => AppCubit())],
        child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
              home: startWidget,
            );
          },
        ));
  }
}
