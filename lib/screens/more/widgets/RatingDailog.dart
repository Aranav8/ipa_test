// ignore_for_file: curly_braces_in_flow_control_structures, use_build_context_synchronously, file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../rental/MyHomePage.dart';

class RatingDailog extends StatefulWidget {
  const RatingDailog({super.key});

  @override
  State<RatingDailog> createState() => _RatingDailogState();
}

enum Availability { loading, available, unavailable }

class _RatingDailogState extends State<RatingDailog> {
  int star = 5;
  Color col = Colors.red;
  Color colAccent = Colors.redAccent;

  final isAndroid = Platform.isAndroid;

  void close() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return ClipPath(
      child: Container(
        height: 550,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          border: Border.all(color: Colors.grey),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              child: ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [col, colAccent, colAccent.withOpacity(0.65)],
                    ),
                  ),
                  height: 300,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => close(),
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.white,
                      ),
                      Text(
                        'Rate your Experience',
                        style: TextStyle(
                            color: Colors.white, fontSize: 16 / scaleFactor),
                      ),
                    ],
                  ),
                  Image.asset(
                    'assets/images/rating.png',
                    width: 300,
                  ),
                  Text(
                    'Your opinion matters to us!',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 22 / scaleFactor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    textAlign: TextAlign.center,
                    'We work super hard to serve you best and would love to know how would you rate our app?',
                    style: TextStyle(
                      fontSize: 14 / scaleFactor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  isAndroid
                      ? Padding(
                          padding: const EdgeInsets.all(15),
                          child: Image.asset(
                            'assets/images/google_play_store.jpg',
                            width: 200,
                          ),
                        )
                      : Card(
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            width: 170,
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  'assets/images/app_store_logo.png',
                                  height: 40,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'IOS APP ON',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10 / scaleFactor),
                                    ),
                                    Text(
                                      'App Store',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22 / scaleFactor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 64,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => close(),
                      child: Text(
                        textAlign: TextAlign.center,
                        'Not Now',
                        style: TextStyle(
                            color: colAccent, fontSize: 15 / scaleFactor),
                      ),
                    ),
                    const SizedBox(height: 7),
                    GestureDetector(
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setInt('rating_box', DateTime.now().month);
                        const playStoreUrl =
                            'https://play.google.com/store/apps/details?id=com.ridobikocustomer.app';
                        const appStoreUrl =
                            'https://www.apple.com/in/app-store/';
                        await launchUrl(
                          Uri.parse(isAndroid ? playStoreUrl : appStoreUrl),
                          mode: LaunchMode.externalApplication,
                        );
                        Navigator.pop(context);
                      },
                      child: Container(
                        color: colAccent,
                        child: SizedBox(
                          height: 38,
                          child: Center(
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 20 / scaleFactor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 220);
    path.quadraticBezierTo(size.width / 4, 160, size.width / 2, 175);
    path.quadraticBezierTo(3 / 4 * size.width, 190, size.width, 130);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
