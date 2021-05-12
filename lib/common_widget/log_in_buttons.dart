import 'package:flutter/material.dart';

class LogInButton extends StatelessWidget {
  final String btnText;
  final Color btnColor;
  final Color btnTextColor;
  final double btnTextSize;
  final double btnRadius;
  final double btnHeight;
  final Widget btnIcon;
  final VoidCallback btnPressed;

  const LogInButton(
      {Key key,
      @required this.btnText,
      this.btnColor,
      this.btnTextColor: Colors.white,
      this.btnTextSize: 18,
      this.btnRadius: 10,
      this.btnHeight,
      this.btnIcon,
      this.btnPressed})
      : assert(btnText != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(6),
              minimumSize: Size(150, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(btnRadius),
              ),
              primary: btnColor),
          onPressed: btnPressed,
          icon: btnIcon != null ? btnIcon : Container(),
          label: Text(
            btnText,
            style: TextStyle(fontSize: 20, color: btnTextColor),
          ),
        ),
      ],
    );
  }
}
