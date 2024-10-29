import 'package:daily_planner/core/state_management/auth_provider.dart';
import 'package:daily_planner/core/style/routes_manager.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../core/style/strings_manager.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthUserProvider provider=Provider.of<AuthUserProvider>(context);
    Future.delayed(const Duration(seconds: 4),()async{
      if(provider.isLogged()){
        await provider.retrieveData();
        Navigator.pushNamedAndRemoveUntil(context, RoutesManager.homeName, (route) => false);
      }else {
        Navigator.pushNamedAndRemoveUntil(context, RoutesManager.loginName, (route) => false);
      }
    });
    return Scaffold(
      body: Center(
        child: Lottie.asset(StringsManager.splash),
      ),
    );
  }
}
