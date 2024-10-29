import 'package:daily_planner/core/style/routes_manager.dart';
import 'package:daily_planner/core/style/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.topLeft,
                child: SvgPicture.asset(StringsManager.bgImage)).animate().fade(
                duration: const Duration(seconds: 4)),
            Lottie.asset(StringsManager.getImage),
            Padding(
              padding:REdgeInsets.only(
                left: 50,
                right: 50,
                top: 20,
                bottom: 20,
              ),
              child: Text(StringsManager.welcome,
              style: Theme.of(context).textTheme.titleLarge,).animate().slideX(duration: const Duration(seconds: 1)),
            ),
            Padding(
              padding: REdgeInsets.all(25.0),
              child: Text(StringsManager.appDescription,
              style: Theme.of(context).textTheme.titleSmall,),
            ).animate().slideX(duration: const Duration(seconds: 1),
            begin: 1,end: 0),
            const Spacer(),
            Padding(
              padding: REdgeInsets.all(35.0),
              child: ElevatedButton(onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, RoutesManager.loginName, (route) => false);
              }, child: Padding(
                padding: REdgeInsets.all(15.0),
                child: const Text(StringsManager.getStarted),
              )).animate().fade(duration: const Duration(seconds: 4)),
            )

          ],
        ),
      ),
    );
  }
}
