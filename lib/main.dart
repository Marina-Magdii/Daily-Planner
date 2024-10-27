import 'package:daily_planner/core/style/app_style.dart';
import 'package:daily_planner/core/routes_manager.dart';
import 'package:daily_planner/features/get_statred/get_started.dart';
import 'package:daily_planner/features/home/home_view.dart';
import 'package:daily_planner/features/login/login_view.dart';
import 'package:daily_planner/features/sign_up/sign_up_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/firebase/firebase_options.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      ensureScreenSize: true,
      splitScreenMode: true,
      minTextAdapt: true,
      designSize: const Size(430, 932),
      builder: (context, child) {
        return  MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppStyle.lightTheme,
          initialRoute: RoutesManager.getStarted,
          routes: {
            RoutesManager.homeName:(_)=>HomeView(),
            RoutesManager.getStarted:(_)=>GetStarted(),
            RoutesManager.signUpName:(_)=>SignUp(),
            RoutesManager.loginName:(_)=>Login()
          },
          title: 'Daily Planner',
        );
      },
    );
  }
}
