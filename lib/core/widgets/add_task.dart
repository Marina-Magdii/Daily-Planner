import 'package:daily_planner/core/style/strings_manager.dart';
import 'package:daily_planner/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddTask extends StatefulWidget {
   const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TextEditingController titleController = TextEditingController();

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
                isPass: false)
          ],
        ),
      ),
    );
  }

  addTask(){
    if(formKey.currentState?.validate()??false){

    }
  }
}
