import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingAadhaarWidget extends StatelessWidget {
  const LoadingAadhaarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.black),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Image.asset(
            'assets/images/top_aadhaar.jpg',
            fit: BoxFit.fitWidth,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  child: SizedBox(
                    height: 160,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.white,
                        child: Container(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    height: 155,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.white,
                          child: Container(
                            color: Colors.white,
                            height: 22,
                            width: 130,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.white,
                          child: Container(
                            color: Colors.white,
                            height: 22,
                            width: 80,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.white,
                          child: Container(
                            color: Colors.white,
                            height: 22,
                            width: 60,
                          ),
                        ),
                        Expanded(child: Container()),
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.white,
                          child: Container(
                            color: Colors.white,
                            height: 22,
                            width: 130,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          const Divider(thickness: 1, color: Colors.black54),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.white,
              child: Container(
                color: Colors.white,
                height: 18,
                width: 60,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.white,
              child: Container(
                color: Colors.white,
                height: 18,
                width: 220,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.white,
              child: Container(
                color: Colors.white,
                height: 18,
                width: 220,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.white,
              child: Container(
                color: Colors.white,
                height: 18,
                width: 180,
              ),
            ),
          ),
          const Divider(thickness: 1, color: Colors.black54),
          Image.asset('assets/images/footer_aadhaar_1.jpg'),
          const Divider(thickness: 1, color: Colors.redAccent),
          Image.asset('assets/images/footer_aadhaar_2.jpg'),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
