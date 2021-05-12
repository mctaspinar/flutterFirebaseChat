import 'package:flutter/material.dart';

class EmptyListScreen extends StatelessWidget {
  final IconData iconData;
  final String message;

  EmptyListScreen({@required this.iconData, @required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 150,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: Theme.of(context).primaryColor,
              size: 120,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                message,
                style: TextStyle(
                    color: Colors.black.withOpacity(.3), fontSize: 16),
              ),
            ),
            Text(
              "Yenilemek için aşağıya kaydırın..",
              style:
                  TextStyle(color: Colors.black.withOpacity(.3), fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
