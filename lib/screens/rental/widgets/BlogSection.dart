// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BlogSection extends StatelessWidget {
  String title;
  String subtitle;
  String trailingImage;
  VoidCallback onTab;
  Color color;

  BlogSection(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.onTab,
      required this.trailingImage,
      required this.color});

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return GestureDetector(
      onTap: onTab,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(5),
            width: 300,
            height: 200,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10,
                  )
                ],
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: trailingImage,
                      fit: BoxFit.cover,
                      height: 200,
                      width: 300,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        height: 34,
                        width: double.maxFinite,
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 14 / scaleFactor,
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
