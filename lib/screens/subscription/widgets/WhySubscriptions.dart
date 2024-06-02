// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';

class WhySub extends StatelessWidget {
  String title;

  Widget trailingImage;
  VoidCallback onTab;
  Color color;
  Color cardColor;

  WhySub(
      {super.key,
      required this.title,
      required this.trailingImage,
      required this.onTab,
      required this.color,
      required this.cardColor});
  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
      child: GestureDetector(
        onTap: onTab,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              elevation: 7,
              color: cardColor,
              child: Container(
                height: 100,
                width: 200,
                padding: const EdgeInsets.only(left: 80, right: 10),
                alignment: Alignment.center,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 13 / scaleFactor),
                  ),
                ),
              ),
            ),
            Container(
              height: 65,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              margin: const EdgeInsets.only(left: 4),
              child: trailingImage,
            ),
          ],
        ),
      ),
    );
  }
}
