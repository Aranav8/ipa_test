import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingAnimation extends StatelessWidget {
  final String message;
  const LoadingAnimation({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 2000,
          width: 2000,
          color: Colors.black.withOpacity(0.5),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Center(
            child: SizedBox(
              height: 130,
              width: 230,
              child: Card(
                color: Colors.white,
                surfaceTintColor: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      message,
                      style:
                          const TextStyle(fontFamily: "poppinsM", fontSize: 13),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: Lottie.asset("assets/json/loadingAnimation.json",
                          height: 60, width: 60),
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
