import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showCustomDialog(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        CupertinoDialogAction(
          child: Text('확인'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}
