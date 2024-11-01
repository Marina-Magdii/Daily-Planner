import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_planner/core/firebase/task_collection.dart';
import 'package:daily_planner/core/state_management/auth_provider.dart';
import 'package:daily_planner/core/style/strings_manager.dart';
import 'package:daily_planner/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../firebase/task.dart';
import '../style/colors_manager.dart';

class TaskSheet extends StatefulWidget {
   const TaskSheet({super.key});

  @override
  State<TaskSheet> createState() => _TaskSheetState();
}

class _TaskSheetState extends State<TaskSheet> {
  final TextEditingController titleController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final GlobalKey<FormState>formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize:MainAxisSize.min,
          children: [
            Padding(
              padding: REdgeInsets.all(25.0),
              child: Text(StringsManager.addTask,style: Theme.of(context).textTheme.titleLarge,),
            ),
            SizedBox(height: 20.h,),
            CustomTextField(
                hintText: StringsManager.title,
                validator: (value){
                  if (value == null || value.isEmpty) {
                    return StringsManager.empty;
                  }
                  return null;
                },
                obscure: false,
                controller: titleController,
                isPass: false),
            SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom,
            ),
            Padding(
              padding: REdgeInsets.all(15.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(StringsManager.selectDate,style: Theme.of(context).textTheme.titleMedium)),
            ),
            InkWell(
              onTap: (){
                changeDate();
              },
              child: Padding(
                padding: REdgeInsets.all(15.0),
                child: Text("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20.sp,
                  fontFamily: StringsManager.fontFamily
                )),
              ),
            ),
            Padding(
              padding: REdgeInsets.all(15.0),
              child: ElevatedButton(onPressed: (){
                addTask();
                Navigator.pop(context);
              }, child: const Text(StringsManager.addTask)),
            )
          ],
        ),
      ),
    );
  }
  addTask()async{
    Lottie.asset(StringsManager.loading);
    AuthUserProvider provider = Provider.of<AuthUserProvider>(context,listen: false);
    if(formKey.currentState?.validate()??false){
       await TaskCollection.createTask(provider.fireBUser!.uid, Task(
         title: titleController.text,
         id: provider.fireBUser!.uid,
         date: Timestamp.fromMillisecondsSinceEpoch(selectedDate.millisecondsSinceEpoch),
       ));
       await Fluttertoast.showToast(
           msg: StringsManager.taskCreated,
           gravity: ToastGravity.BOTTOM,
           backgroundColor: ColorsManager.primary,
           textColor: Colors.white,
           toastLength: Toast.LENGTH_LONG);
    }
  }
  changeDate()async{
    DateTime? newDate = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)));
    if (newDate!= null) {
      setState(() {
        selectedDate = newDate;
      });
    }
  }
}
