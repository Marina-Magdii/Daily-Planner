import 'package:daily_planner/core/colors_manager.dart';
import 'package:daily_planner/core/firebase/firestore_helper.dart';
import 'package:daily_planner/core/firebase/user.dart'as MyUser;
import 'package:daily_planner/core/regex.dart';
import 'package:daily_planner/core/routes_manager.dart';
import 'package:daily_planner/core/strings_manager.dart';
import 'package:daily_planner/core/widgets/custom_dialog.dart';
import 'package:daily_planner/core/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: SvgPicture.asset(StringsManager.bgImage)
                    .animate()
                    .fade(duration: const Duration(seconds: 5))),
            Center(
                child: Text(
              StringsManager.welcomeBack,
              style: Theme.of(context).textTheme.titleLarge,
            )),
            SvgPicture.asset(StringsManager.loginPic)
                .animate()
                .fade(duration: const Duration(seconds: 3)),
            SizedBox(
              height: 50.h,
            ),
            CustomTextField(
              isPass: false,
              hintText: StringsManager.enterEmail,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return StringsManager.empty;
                } else if (!emailValid(value)) {
                  return StringsManager.invalidEmail;
                }
                return null;
              },
              obscure: false,
              controller: emailController,
            ).animate().slideX(duration: const Duration(seconds: 1)),
            CustomTextField(
              isPass: true,
              hintText: StringsManager.enterPass,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return StringsManager.empty;
                } else if (value.length < 6) {
                  return StringsManager.shortPass;
                }
                return null;
              },
              obscure: true,
              controller: passController,
            ).animate().slideX(
                duration: const Duration(
                  seconds: 1,
                ),
                begin: 1.0,
                end: 0),
            SizedBox(
              height: 30.h,
            ),
            Padding(
              padding: REdgeInsets.all(20.0),
              child: ElevatedButton(
                  onPressed: () {
                    signIn();
                  },
                  child: Padding(
                    padding: REdgeInsets.all(15.0),
                    child: const Text(StringsManager.login),
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(StringsManager.noAcc),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, RoutesManager.signUpName, (route) => false);
                    },
                    child: Text(
                      StringsManager.register,
                      style: TextStyle(
                          color: ColorsManager.primary, fontSize: 20.sp),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  signIn() async {
    if (formKey.currentState?.validate()??false) {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text.trim(), password: passController.text);
        Center(
          child: Lottie.asset(StringsManager.loading,
          ),
        );
        MyUser.User? user =await FirestoreHelper.getUser(credential.user!.uid);
        Fluttertoast.showToast(msg: StringsManager.accCreated);
        Navigator.pushNamedAndRemoveUntil(
            context, RoutesManager.homeName, (route) => false,
        arguments: user!.name);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showDialog(
            context: context,
            builder: (context) => const CustomDialog(content: Text(StringsManager.noUser)),);
          // return
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(content: Text(StringsManager.noUser)));
        } else if (e.code == 'wrong-password') {
          showDialog(
            context: context,
            builder: (context) => const CustomDialog(content: Text(StringsManager.wrongPass)),);
          // return ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(content: Text(StringsManager.wrongPass)));
        }
      }
    }
  }
}
