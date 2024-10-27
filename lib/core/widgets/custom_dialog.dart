import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({super.key, required this.content});
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: content,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
    child:  Text("OK",
    style: Theme.of(context).textTheme.titleSmall,),)]
    );
  }
}
