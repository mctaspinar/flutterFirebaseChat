import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_chat/common_widget/widget_base.dart';

class CustomAlertDialog extends WidgetBase {
  final String title;
  final String content;
  final String actionText;
  final String cancelText;
  final BuildContext context;

  CustomAlertDialog(
      {@required this.title,
      @required this.content,
      @required this.actionText,
      this.context,
      this.cancelText});

  Future<bool> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog(
            context: context, builder: (context) => this)
        : await showDialog(
            context: context,
            builder: (context) => this,
            barrierDismissible: false);
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: Text(content),
        actions: _dialogButtons(context));
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: Text(content),
        actions: _dialogButtons(context));
  }

  List<Widget> _dialogButtons(BuildContext context) {
    final allButtons = <Widget>[];
    if (Platform.isIOS) {
      if (cancelText != null) {
        allButtons.add(
          CupertinoDialogAction(
            child: Text(cancelText),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        );
      }
      allButtons.add(
        CupertinoDialogAction(
          child: Text(actionText),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      );
    } else {
      if (cancelText != null) {
        allButtons.add(
          TextButton(
            child: Text(cancelText),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        );
      }
      allButtons.add(
        TextButton(
          child: Text(actionText),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      );
    }
    return allButtons;
  }
}
