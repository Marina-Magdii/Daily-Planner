import 'package:daily_planner/core/state_management/auth_provider.dart';
import 'package:daily_planner/core/style/colors_manager.dart';
import 'package:daily_planner/core/style/strings_manager.dart';
import 'package:daily_planner/core/widgets/add_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'dart:core';
import '../../core/widgets/task_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    AuthUserProvider provider=Provider.of<AuthUserProvider>(context);
    var args = ModalRoute.of(context)?.settings.arguments;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        // bottomNavigationBar: ,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  color: ColorsManager.primary,
                  height: 300.h,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        const Spacer(),
                        CircleAvatar(
                          radius: 70.r,
                          backgroundImage: const AssetImage(StringsManager.pic),
                        ),
                        Padding(
                          padding: REdgeInsets.all(10.0),
                          child: Text(
                            "${StringsManager.welcomeBack}, $args",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SvgPicture.asset(StringsManager.bgImage),
                Padding(
                  padding: REdgeInsets.all(30.0),
                  child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: () {
                           provider.signOut(context);
                          },
                          icon: Icon(
                            Icons.login_outlined,
                            size: 30.sp,
                            color: Colors.white,
                          ))),
                )
              ],
            ),
            Padding(
              padding: REdgeInsets.all(20.0),
              child: Text(
                StringsManager.tasksList,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: Padding(
                padding: REdgeInsets.all(30.0),
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 5.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(30.r),
                      color: Colors.white),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: REdgeInsets.all(20.0),
                            child: Text(StringsManager.dailyTasks,
                            style: Theme.of(context).textTheme.titleMedium,),
                          ),
                          Padding(
                            padding: REdgeInsets.all(10.0),
                            child: IconButton(onPressed: (){
                              showModalBottomSheet(
                                isScrollControlled: true,
                                  context: context,
                                  builder: (context) => const AddTask());
                            }, icon: Icon(Icons.add,
                            size: 30.sp,color: ColorsManager.primary,)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 2,
                          itemBuilder: (context, index) => const TaskWidget(
                            task: "Go to the gym",
                          )),
                    )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
