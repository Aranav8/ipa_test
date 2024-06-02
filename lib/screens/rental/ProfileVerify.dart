// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridobiko/controllers/auth/auth_controller.dart';
import 'package:ridobiko/data/user_model.dart';
import 'package:ridobiko/screens/more/DocumentUpload.dart';
import 'package:ridobiko/screens/more/MyAccount.dart';
import 'package:ridobiko/screens/more/NewSecurityDeposit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileVerify extends ConsumerStatefulWidget {
  const ProfileVerify({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return profileVerify();
  }
}

// ignore: camel_case_types
class profileVerify extends ConsumerState {
  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 200,
                    padding: const EdgeInsets.only(top: 20, bottom: 30),
                    child: SvgPicture.asset("assets/images/mobile.svg"),
                  ),
                  Text(
                    "Verify Profile Now",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20 / scaleFactor),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          right: 30, left: 30, top: 10, bottom: 30),
                      child: Text(
                        "We need to verify your information please submit the documents bellow to process your application",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14 / scaleFactor, color: Colors.grey),
                      )),
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.grey[200],
                    ),
                    child: Text(
                      "VERIFY YOUR PROFILE IN 3 SIMPLE STEPS",
                      style: TextStyle(
                        letterSpacing: 1,
                        color: Colors.black,
                        fontSize: 13 / scaleFactor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyAccount()));
                      },
                      leading: Image.asset("assets/images/NUmber-step-1.png"),
                      title: Text(
                        'Upload Profile',
                        style: TextStyle(
                            fontSize: 14 / scaleFactor,
                            color: Colors.grey[800]),
                      )),
                  const Divider(
                    thickness: 0.5,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DocUpload()));
                      },
                      leading: Image.asset("assets/images/NUmber-step-2.png"),
                      title: Text(
                        'Upload Documents',
                        style: TextStyle(
                            fontSize: 14 / scaleFactor,
                            color: Colors.grey[800]),
                      )),
                  const Divider(
                    thickness: 0.5,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewSecurityDepoPB()));
                      },
                      leading: Image.asset("assets/images/NUmber-step-3.png"),
                      title: Text(
                        'Add deposit',
                        style: TextStyle(
                            fontSize: 14 / scaleFactor,
                            color: Colors.grey[800]),
                      )),
                  const SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    onTap: () {
                      UserModel user = ref.read(userProvider)!;
                      if (user.emergencyMobileVerified != "1" ||
                          user.emailVerified != "1") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyAccount()));
                      } else if (user.aadhaarVerified2 != "1" ||
                          user.dlVerified != "1") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DocUpload()));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewSecurityDepoPB()));
                      }
                    },
                    child: Card(
                      elevation: 5,
                      margin: const EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color.fromRGBO(139, 0, 0, 1),
                                  Colors.red[200]!
                                ])),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Proceed To Complete Profile Verification",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15 / scaleFactor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
