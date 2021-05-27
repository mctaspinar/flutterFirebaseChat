import "package:flutter/material.dart";
import 'package:shimmer/shimmer.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(45),
                    ),
                    color: Colors.grey[300],
                  ),
                ),
              ),
              title: SizedBox(
                width: 120,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  child: Container(
                    height: 15,
                    color: Colors.grey[300],
                  ),
                ),
              ),
              subtitle: SizedBox(
                width: 80,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  child: Container(
                    height: 15,
                    color: Colors.grey[300],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
