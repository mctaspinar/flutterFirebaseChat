import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final String imgPath;
  final Function clickFunc;
  SocialButton({this.imgPath, this.clickFunc});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: InkWell(
        onTap: clickFunc,
        child: Image.asset(imgPath),
      ),
    );
  }
}
