import 'package:daily_planner/core/firebase/task_collection.dart';
import 'package:daily_planner/core/state_management/auth_provider.dart';
import 'package:daily_planner/core/style/colors_manager.dart';
import 'package:daily_planner/core/style/strings_manager.dart';
import 'package:daily_planner/core/widgets/task_sheet.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'dart:core';
import '../../core/firebase/task.dart';
import '../../core/widgets/task_widget.dart';

class HomeView extends StatefulWidget {
   HomeView({super.key});
  DateTime selectedDate=DateTime(
     DateTime.now().year,
     DateTime.now().month,
     DateTime.now().day,
  );

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    AuthUserProvider provider=Provider.of<AuthUserProvider>(context);
    var args = ModalRoute.of(context)?.settings.arguments;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
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
                            color: ColorsManager.secondary,
                          ))),
                )
              ],
            ),
            EasyInfiniteDateTimeLine(
              firstDate:DateTime.now(),
              focusDate: widget.selectedDate,
              lastDate: DateTime.now().add(const Duration(days: 365)),
              onDateChange: (selectedDate) {
                setState(() {
                  widget.selectedDate = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                  );
                });
              },
            ),
            Padding(
              padding: REdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text(
                    StringsManager.tasksList,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Padding(
                    padding: REdgeInsets.all(5.0),
                    child: IconButton(onPressed: (){
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => const TaskSheet());
                    }, icon: Icon(Icons.add,
                      size: 30.sp,color: ColorsManager.primary,)),
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: REdgeInsets.all(30.0),
                child: Column(
                  children: [
                  FutureBuilder(
                    future: TaskCollection.getTasks(provider.fireBUser?.uid??"",widget.selectedDate
                    ),
                    builder: (context, snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Lottie.asset(StringsManager.loading);
                      }
                      if(snapshot.hasError){
                        return Padding(
                          padding: REdgeInsets.all(15.0),
                          child: Text("Error: ${snapshot.error.toString()}"),
                        );
                      }
                      if(snapshot.hasData){
                        List<Task> tasks=snapshot.data??[];
                        if(tasks.isEmpty){
                          return Column(
                            children: [
                              Padding(
                                padding: REdgeInsets.all(15.0),
                                child:  Center(child: Text(StringsManager.noTaskCreated,
                                style: Theme.of(context).textTheme.titleMedium)),
                              ),
                              SizedBox(
                                  height: 200.h ,
                                  child: Lottie.asset(StringsManager.noTasksAnimi))
                            ],
                          );  // add no tasks widget here if needed  else, return null or an empty list.
                        }
                        return Expanded(
                          child: ListView.builder(
                            itemCount: tasks.length,
                            itemBuilder: (context, index){
                              return TaskWidget(task: tasks[index]);
                            },
                          ),
                        );
                      }
                      return Lottie.asset(StringsManager.loading);
                    })
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
