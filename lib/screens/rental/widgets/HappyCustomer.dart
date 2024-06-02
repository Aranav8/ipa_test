// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';

class HappyCust extends StatelessWidget {
  String title;
  String subtitle;
  VoidCallback onTab;
  Color color;

  HappyCust(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.onTab,
      required this.color});
  double maxHeight = 0;

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 300,
          height: 220,
          margin: const EdgeInsets.all(10),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 10,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 18 / scaleFactor,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                          fontSize: 14 / scaleFactor,
                          color: Colors.grey[600],
                          overflow: TextOverflow.fade),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
