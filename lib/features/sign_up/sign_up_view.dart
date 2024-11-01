import 'package:daily_planner/core/state_management/auth_provider.dart';
import 'package:daily_planner/core/style/colors_manager.dart';
import 'package:daily_planner/core/constants/regex.dart';
import 'package:daily_planner/core/style/routes_manager.dart';
import 'package:daily_planner/core/style/strings_manager.dart';
import 'package:daily_planner/core/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../core/firebase/firestore_helper.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});

  final TextEditingController emailController = TextEditingController();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController passController = TextEditingController();

  final TextEditingController confirmController = TextEditingController();

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
                    child: SvgPicture.asset(StringsManager.bgImage))
                .animate()
                .fade(duration: const Duration(seconds: 4)),
            Padding(
              padding: REdgeInsets.all(20.0),
              child: Text(
                StringsManager.welcome,
                style: Theme.of(context).textTheme.titleLarge,
              ).animate().fade(duration: const Duration(seconds: 4)),
            ),
            Center(
              child: Padding(
                padding: REdgeInsets.all(20.0),
                child: const Text(StringsManager.welcomeOnBoard)
                    .animate()
                    .fade(duration: const Duration(seconds: 4)),
              ),
            ),
            CustomTextField(
                    hintText: StringsManager.enterName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return StringsManager.empty;
                      }
                      return null;
                    },
                    obscure: false,
                    controller: nameController,
                    isPass: false)
                .animate()
                .slideX(
                    duration: const Duration(
                      seconds: 1,
                    ),
                    begin: 1.0,
                    end: 0),
            CustomTextField(
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
                    isPass: false)
                .animate()
                .slideX(
                  duration: const Duration(
                    seconds: 1,
                  ),
                ),
            CustomTextField(
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
                    isPass: true)
                .animate()
                .slideX(
                    duration: const Duration(
                      seconds: 1,
                    ),
                    begin: 1.0,
                    end: 0),
            CustomTextField(
                    hintText: StringsManager.confirmPass,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return StringsManager.empty;
                      } else if (value.length < 6) {
                        return StringsManager.shortPass;
                      } else if (value != passController.text) {
                        return StringsManager.passNotMatch;
                      }
                      return null;
                    },
                    obscure: true,
                    controller: confirmController,
                    isPass: true)
                .animate()
                .slideX(
                  duration: const Duration(
                    seconds: 1,
                  ),
                ),
            SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom,
            ),
            Padding(
              padding: REdgeInsets.all(20.0),
              child: ElevatedButton(
                  onPressed: () {
                    signup(context);
                  },
                  child: Padding(
                    padding: REdgeInsets.all(15.0),
                    child: const Text(StringsManager.register),
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(StringsManager.hasAcc),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RoutesManager.loginName);
                    },
                    child: Text(
                      StringsManager.login,
                      style: TextStyle(
                          fontSize: 20.sp, color: ColorsManager.primary),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  signup(BuildContext context) async {
    AuthUserProvider authProvider=Provider.of<AuthUserProvider>(context,listen: false);
    Lottie.asset(
      StringsManager.loading,
    );
    if (formKey.currentState?.validate() ?? false) {
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passController.text,
        );
        var user = FirestoreHelper.addUser(
            name: nameController.text,
            email: emailController.text,
            userId: credential.user!.uid);
        authProvider.setUsers(user, credential.user);
        Fluttertoast.showToast(
            msg: StringsManager.accCreated,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: ColorsManager.primary,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_LONG);
        Navigator.pushNamedAndRemoveUntil(
            context, RoutesManager.homeName, (route) => false);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          return ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(StringsManager.shortPass)));
        } else if (e.code == 'email-already-in-use') {
          return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(StringsManager.usedEmail),
          ));
        }
      } catch (e) {
        return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
        ));
      }
    }
  }
}
