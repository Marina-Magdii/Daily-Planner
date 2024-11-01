import 'package:daily_planner/core/firebase/task_collection.dart';
import 'package:daily_planner/core/state_management/auth_provider.dart';
import 'package:daily_planner/core/style/colors_manager.dart';
import 'package:daily_planner/core/style/strings_manager.dart';
import 'package:daily_planner/core/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../firebase/task.dart';

class TaskWidget extends StatefulWidget {
  TaskWidget({super.key, required this.task});
  Task task;

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  bool done = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.only(bottom: 10),
      child: Slidable(
        startActionPane: ActionPane(
          motion: const BehindMotion(),
          extentRatio: 0.3,
          children: [
            SlidableAction(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  bottomLeft: Radius.circular(20.r)),
              onPressed: (context) {
                deleteTask();
              },
              backgroundColor: ColorsManager.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 5.0,
            ),
          ], borderRadius: BorderRadius.circular(30.r), color: Colors.white),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    done = !done;
                  },
                  icon: done
                      ? const Icon(Icons.check_box_rounded)
                      : const Icon(Icons.square_outlined)),
              Text(
                widget.task.title ?? "",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  deleteTask() async {
    AuthUserProvider provider =
        Provider.of<AuthUserProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
          onTap: () async {
            Navigator.pop(context);
            await TaskCollection.deleteTask(
                provider.fireBUser!.uid, widget.task.id ?? "");
          },
          content: const Text(StringsManager.deleteConfirm)),
    );
  }
}
