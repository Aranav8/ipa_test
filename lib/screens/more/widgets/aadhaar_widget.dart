import 'package:digilocker_client/model/Aadhaar.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

class AadhaarWidget extends StatelessWidget {
  const AadhaarWidget({
    super.key,
    required this.screenshotController,
    required this.aadhaarData,
  });

  final ScreenshotController screenshotController;
  final Aadhaar aadhaarData;

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return Screenshot(
      controller: screenshotController,
      child: Container(
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
                        child:
                            Image.memory(aadhaarData.photo, fit: BoxFit.cover),
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
                          Text(
                            aadhaarData.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16 / scaleFactor,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'DOB : ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16 / scaleFactor,
                                ),
                              ),
                              Text(
                                aadhaarData.dob,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16 / scaleFactor,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            aadhaarData.gender,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16 / scaleFactor,
                            ),
                          ),
                          Expanded(child: Container()),
                          Text(
                            aadhaarData.uid.replaceAll('x', 'X'),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16 / scaleFactor,
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
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Address : ',
                style: TextStyle(
                    fontSize: 14 / scaleFactor, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                '${aadhaarData.co}, ${aadhaarData.house}, ${aadhaarData.lm}, ${aadhaarData.loc} ${aadhaarData.street} ${aadhaarData.dist}, ${aadhaarData.state}, ${aadhaarData.pc}',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17 / scaleFactor,
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
      ),
    );
  }
}
