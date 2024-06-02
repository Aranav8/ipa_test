// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:oauth2_client/access_token_response.dart';
// import 'package:oauth2_client/oauth2_client.dart';
import 'package:ridobiko/screens/more/AadharUpload.dart';
import 'package:ridobiko/screens/more/LicenseUpload.dart';
import 'package:ridobiko/controllers/auth/auth_controller.dart';
import 'package:ridobiko/data/BookingFlow.dart';
import 'package:ridobiko/data/documents.dart';
import 'package:ridobiko/data/user_model.dart';
import 'package:ridobiko/screens/more/NewSecurityDeposit.dart';
import 'package:ridobiko/screens/more/digilocker_verification.dart';

import '../rental/MyHomePage.dart';

class DocUpload extends ConsumerStatefulWidget {
  const DocUpload({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return docUpload();
  }
}

class docUpload extends ConsumerState {
  String isAadhaarUploaded = "";
  String isLicenseUpload = "";

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;
    UserModel? user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          if (BookingFlow.fromMore == false)
            TextButton(
              onPressed: () {
                int securityDeposit = BookingFlow.selectedBikeSubs != null
                    ? int.parse(BookingFlow.selectedBikeSubs!.deposit!)
                    : int.parse(BookingFlow.selectedBike!.deposit!);

                BookingFlow.fromMore
                    ? Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => const MyHomePage()),
                        (route) => false)
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) =>
                                NewSecurityDepoPB(securityDeposit)),
                      );
              },
              child: Text('NEXT', style: TextStyle(fontSize: 14 / scaleFactor)),
            )
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.only(right: 20, left: 20, bottom: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Documents Verification',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0 / scaleFactor,
                            fontWeight: FontWeight.bold),
                      )),
                  Padding(
                      padding:
                          const EdgeInsets.only(top: 10, right: 40, bottom: 5),
                      child: Text(
                        'Upload documents and send them to us for processing',
                        style: TextStyle(
                            color: Colors.grey, fontSize: 15.0 / scaleFactor),
                      )),
                  if (user!.aadhaarVerified2 != '1' || user.dlVerified != '1')
                    const Divider(
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (user.aadhaarVerified2 != '1' ||
                      user.drivingLicenseVerified != '1')
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "1. Digilocker is a mandatory process.",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5 / scaleFactor,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (user.aadhaarVerified2 != '1' ||
                      user.drivingLicenseVerified != '1')
                    Text(
                      "2. Manual verification can only be considered in case of partial verification or for Non - Indian Residence.",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5 / scaleFactor,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (user.aadhaarVerified2 != '1' ||
                      user.drivingLicenseVerified != '1')
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "3. Please Note Manual Verification can cost upto 45 mintues at Ridobiko Store.",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5 / scaleFactor,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  if (user.aadhaarVerified2 == '1')
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AadharUpload()));
                      },
                      leading: SvgPicture.asset(
                        "assets/images/aadhar.svg",
                        height: 30,
                        width: 30,
                      ),
                      title: Text(
                        'Aadhaar Card',
                        style: TextStyle(
                            fontSize: 14 / scaleFactor,
                            color: Colors.grey[800]),
                      ),
                      trailing: const Icon(
                        // Icons.keyboard_arrow_right_outlined,
                        Icons.verified,
                        color: Colors.blueAccent,
                      ),
                    ),
                  if (user.aadhaarVerified2 == '1')
                    const Divider(
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (user.drivingLicenseVerified == '1')
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LicenseUpload()));
                      },
                      leading: SvgPicture.asset(
                        "assets/images/license.svg",
                        height: 30,
                        width: 30,
                      ),
                      title: Text(
                        'Driving license',
                        style: TextStyle(
                            fontSize: 14 / scaleFactor,
                            color: Colors.grey[800]),
                      ),
                      trailing: const Icon(
                        // Icons.keyboard_arrow_right_outlined,
                        Icons.verified,
                        color: Colors.blueAccent,
                      ),
                    ),
                  if (user.drivingLicenseVerified == '1')
                    const Divider(
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                  // SizedBox(height: 10,),
                  //
                  // ListTile(
                  //   onTap: (){
                  //     _pb? null : Navigator.push(context, MaterialPageRoute(builder: (context) => SelfieUpload()));
                  //   },
                  //   leading: SvgPicture.asset("assets/images/selfie.svg",height: 30, width: 30,),title: Text('Selfie',style: TextStyle(color: Colors.grey[800]),),trailing: Icon(Icons.keyboard_arrow_right_outlined,),),
                  // Divider(thickness: 0.5,color: Colors.grey,),
                ],
              ),
            ),
          ),
          // InkWell(
          //   onTap: (){
          //     Navigator.push(context, MaterialPageRoute(builder: (context) =>AadharUpload()));
          //   },
          //   child: Card(
          //     elevation: 5,
          //     margin: EdgeInsets.all(8),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(10.0),
          //     ),
          //     child: Container(
          //       decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(10.0),
          //           gradient: LinearGradient(begin:Alignment.topLeft,end: Alignment.bottomRight,colors: [Color.fromRGBO(139, 0, 0,1),Colors.red[200]!] )
          //       ),
          //       child: Padding(
          //         padding:  EdgeInsets.all(15),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Text("Proceed Document Upload",style: TextStyle(color: Colors.white,fontSize: 15),),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),

          Visibility(
            visible: !(user.aadhaarVerified2 == '1' &&
                user.drivingLicenseVerified == '1'),
            child: Column(
              children: [
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const DigilockerVerififcationScreen()),
                  ),
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
                              "Fetch From DigiLocker",
                              style: TextStyle(
                                fontSize: 15 / scaleFactor,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _showAlertDialog(context);
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
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Proceed Document Upload",
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
        ],
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: const Text(
            'Please Note',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AadharUpload()));
                },
                child: const Text(
                  "Continue",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color.fromRGBO(139, 0, 0, 1),
                  ),
                )),
          ],
          content: SizedBox(
              width: double.maxFinite,
              height: 110 * MediaQuery.of(context).textScaleFactor,
              child: const Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "1. Digilocker is a mandatory process.",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "2. Manual verification can only be considered in case of partial verification or for Non-Indian Residence.",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "3. Please Note Manual Verification can cost upto 45 mintues at Ridobiko Store.",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }

  void _getUserDetails() async {
    if (ref.read(userProvider)!.aadhaarFront == "") {
      await ref.read(authControllerProvider.notifier).getUserDetails();
    }

    UserModel temp = ref.read(userProvider)!;

    Documents.selfie = temp.profileImage!;

    Documents.adhaar_front = temp.aadhaarFront!;
    Documents.adhaar_back = temp.aadhaarBack!;
    Documents.dl = temp.drivingLicense!;
    Documents.aadhar_verfied = temp.aadhaarVerified2!;
    Documents.dl_verfied = temp.dlVerified!;
  }
}
