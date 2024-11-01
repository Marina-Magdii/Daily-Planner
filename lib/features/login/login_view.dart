import 'package:daily_planner/core/state_management/auth_provider.dart';
import 'package:daily_planner/core/style/colors_manager.dart';
import 'package:daily_planner/core/firebase/firestore_helper.dart';
import 'package:daily_planner/core/firebase/user.dart'as MyUser;
import 'package:daily_planner/core/constants/regex.dart';
import 'package:daily_planner/core/style/routes_manager.dart';
import 'package:daily_planner/core/style/strings_manager.dart';
import 'package:daily_planner/core/widgets/custom_dialog.dart';
import 'package:daily_planner/core/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

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
            SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom,
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
    AuthUserProvider authProvider=Provider.of<AuthUserProvider>(context,listen: false);
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
        authProvider.setUsers(user, credential.user);
        Fluttertoast.showToast(msg: StringsManager.accCreated);
        Navigator.pushNamedAndRemoveUntil(
            context, RoutesManager.homeName, (route) => false,
        arguments: user!.name);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showDialog(
            context: context,
            builder: (context) =>  CustomDialog(
                onTap: (){
                  Navigator.pop(context);
                },
                content: const Text(StringsManager.noUser)),);
          // return
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(content: Text(StringsManager.noUser)));
        } else if (e.code == 'wrong-password') {
          showDialog(
            context: context,
            builder: (context) =>  CustomDialog(
              onTap: (){
                Navigator.pop(context);
              },
                content: Text(StringsManager.wrongPass)),);
          // return ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(content: Text(StringsManager.wrongPass)));
        }
      }
    }
  }
}
