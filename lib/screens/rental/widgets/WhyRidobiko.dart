import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class whyRido extends StatelessWidget {
  String title;
  String subtitle;
  String trailingImage;
  VoidCallback onTab;
  Color color;

  whyRido(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.trailingImage,
      required this.onTab,
      required this.color});

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 10,
            )
          ],
          image: DecorationImage(
            fit: BoxFit.cover,
            opacity: 0.80,
            image: NetworkImage(trailingImage),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.only(bottom: 10),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        trailingImage,
                        width: 70,
                        fit: BoxFit.cover,
                      ),
                    )),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(20),
                ),
                width: 260,
                child: Center(
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Text(title,
                          style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 18 / scaleFactor)),
                    ),
                    subtitle: RichText(
                      text: TextSpan(
                        text: subtitle.substring(0, 60),
                        style: TextStyle(
                          fontSize: 14 / scaleFactor,
                          color: Colors.black87,
                          shadows: const [
                            Shadow(
                              color: Colors.white,
                              blurRadius: 3,
                            )
                          ],
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' Read More',
                            style: TextStyle(
                              fontSize: 14 / scaleFactor,
                              color: Colors.blue,
                              shadows: const [
                                Shadow(
                                  color: Colors.white,
                                  blurRadius: 5,
                                )
                              ],
                            ),
                            recognizer: TapGestureRecognizer()..onTap = onTab,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
