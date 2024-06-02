// ignore_for_file: use_build_context_synchronously, file_names, unused_field, camel_case_types

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ridobiko/core/Constants.dart';
import 'package:ridobiko/screens/more/DocumentUpload.dart';
import 'package:ridobiko/controllers/auth/auth_controller.dart';
import 'package:ridobiko/controllers/more/more_controller.dart';
import 'package:ridobiko/data/BookingFlow.dart';
import 'package:ridobiko/data/user_model.dart';
import 'package:ridobiko/utils/snackbar.dart';
import 'package:http/http.dart' as http;

import '../auth/Login_Screen.dart';

class MyAccount extends ConsumerStatefulWidget {
  const MyAccount({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return profile();
  }
}

class profile extends ConsumerState {
  String _customerName = 'Customer Name';
  String errorText = '';
  bool addressEditable = false;

  String _tempName = "";
  String _tempCustName = "";
  String _tempProfile = "";
  String _tempEmail = "";
  String _tempEmergencyMobile = "";
  String _tempMobile = "";
  String _tempcurrHouse = "";
  String _tempcurrArea = "";
  String _tempcurrLand = "";
  String _tempcuuCity = "";
  String _tempperHouse = "";
  String _tempperArea = "";
  String _tempperLand = "";
  String _tempperCity = "";
  String _tempEmailStatus = "";
  String _tempesataus = "";
  String _relationName = "";
  bool _isDialogShown = false;

  final _name = TextEditingController();
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;

  final _email = TextEditingController();

  final _mobile = TextEditingController();

  // ignore: non_constant_identifier_names
  final _emergency_mobile = TextEditingController();

  final _relationNameController = TextEditingController();

  final _address = TextEditingController();

  final _address_other = TextEditingController();

  String _emailStatus = 'Verify';

  String _eSatatus = 'Verify';

  bool isDisabled = false;

  final _currentHouse = TextEditingController();

  final _relationController = TextEditingController();

  final _currentArea = TextEditingController();

  final _currentLandmark = TextEditingController();

  final _currentCity = TextEditingController();

  final _permanentHouse = TextEditingController();

  final _permanentArea = TextEditingController();

  final _permanentLandmark = TextEditingController();

  final _permanentCity = TextEditingController();

  String? selectedRelation;

  final List<String> relation = [
    "Friend",
    "Sibling",
    "Spouse",
    "Parents",
    "Relative",
    "Other"
  ];

  XFile? _profileImage;
  var _pb = false;
  var _profile = '';

  String mobo = '';

  @override
  void initState() {
    super.initState();

    _getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      body: ListView(
        children: [
          AppBar(
            elevation: 0,
            backgroundColor: const Color.fromRGBO(139, 0, 0, 1),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              Visibility(
                visible: true,
                child: PopupMenuButton<int>(
                  enabled: true,
                  onSelected: (value) async {
                    if (value == 1) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          TextEditingController password =
                              TextEditingController();
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Account Deletion',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18 / scaleFactor),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Hi ${_name.text.isEmpty ? 'User' : _name.text},\nWe\'re sorry to hear you\'d like to delete your account. If you continue, we will delete your account permanentely, You\'ll have to create a new account to use Ridobiko in future.\nConfirm with password :',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(fontSize: 14 / scaleFactor),
                                ),
                                const SizedBox(height: 8),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: password,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    constraints:
                                        const BoxConstraints(maxHeight: 50),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    labelText: 'Password',
                                    labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14 / scaleFactor),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    minimumSize:
                                        const Size(double.maxFinite, 50),
                                  ),
                                  child: Text('Yes, delete my account',
                                      style: TextStyle(
                                          fontSize: 14 / scaleFactor)),
                                  onPressed: () async {
                                    try {
                                      var call = await http.post(
                                          Uri.parse(
                                              '${Constants().url}android_app_customer/api/api_login.php'),
                                          body: {
                                            'mobile': mobo,
                                            'pass': password.text
                                          });
                                      var response = jsonDecode(call.body);
                                      if (response['status'] == true) {
                                        String token =
                                            ref.read(userProvider)!.token!;

                                        await http.post(
                                            Uri.parse(
                                                '${Constants().url}android_app_customer/api/deleteUser.php'),
                                            headers: {
                                              'token': token,
                                            });
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (builder) =>
                                                    const LoginScreen()),
                                            (route) => false);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Error! Try Again...')));
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Some error occurred please try again..")));
                                    }
                                  },
                                ),
                                TextButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        const Size(double.minPositive, 20),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Not Now',
                                      style: TextStyle(
                                          fontSize: 14 / scaleFactor)),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Text("Account Deletion",
                          style: TextStyle(fontSize: 14 / scaleFactor)),
                    ),
                  ],
                  padding: const EdgeInsets.all(5),
                  offset: const Offset(0, 50),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 5,
                ),
              ),
            ],
          ),
          Container(
            color: const Color.fromRGBO(139, 0, 0, 1),
            child: SingleChildScrollView(
              child: Stack(children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 130),
                  padding: const EdgeInsets.only(top: 80, bottom: 30),
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(246, 244, 241, 1),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          topLeft: Radius.circular(20.0))),
                  child: Column(
                    children: [
                      Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side:
                              const BorderSide(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 10,
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, bottom: 10, right: 20),
                          child: Wrap(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.person_pin_rounded,
                                    color: Colors.grey[400],
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        'Customer Name',
                                        style: TextStyle(
                                            decoration: TextDecoration.none,
                                            color: Colors.grey[400],
                                            fontSize: 15 / scaleFactor),
                                      ))
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                child: TextField(
                                  controller: _name,
                                  decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14 / scaleFactor),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      border: InputBorder.none,
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      labelStyle: TextStyle(
                                        fontSize: 17 / scaleFactor,
                                        color: Colors.black,
                                      ),
                                      fillColor: Colors.white,
                                      filled: true),
                                  keyboardType: TextInputType.emailAddress,
                                  obscureText: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side:
                              const BorderSide(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 10,
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, bottom: 10, right: 20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.email_rounded,
                                    color: Colors.grey[400],
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        'E-mail',
                                        style: TextStyle(
                                            decoration: TextDecoration.none,
                                            color: Colors.grey[400],
                                            fontSize: 15 / scaleFactor),
                                      ))
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 5),
                                      child: TextField(
                                        enabled: _emailStatus.toLowerCase() !=
                                            'verified',
                                        controller: _email,
                                        decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                                fontSize: 14 / scaleFactor,
                                                color: Colors.grey),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                                    borderSide:
                                                        BorderSide(
                                                            color: Colors.grey,
                                                            width: 0.5),
                                                    borderRadius: BorderRadius
                                                        .all(
                                                            Radius
                                                                .circular(10))),
                                            border: InputBorder.none,
                                            focusedBorder:
                                                const OutlineInputBorder(
                                                    borderSide:
                                                        BorderSide(
                                                            color: Colors.grey,
                                                            width: 0.5),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                            labelStyle: TextStyle(
                                              fontSize: 17 / scaleFactor,
                                              color: Colors.black,
                                            ),
                                            fillColor: Colors.white,
                                            filled: true),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        obscureText: false,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  GestureDetector(
                                      onTap: _isDialogShown
                                          ? null
                                          : () async {
                                              if (_emailStatus == 'Verified')
                                                return;
                                              var rng = Random();
                                              var code =
                                                  rng.nextInt(9000) + 1000;
                                              _isDialogShown = true;
                                              setState(() {});
                                              await _sendOTPToEmail(code);
                                              _isDialogShown = false;
                                              setState(() {});
                                              Timer? timer2;
                                              Timer? timer;

                                              showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (bContext) {
                                                  var inputCode =
                                                      TextEditingController();
                                                  var errorText = '';
                                                  int countDown = 30;
                                                  bool canResend = false;
                                                  bool emailVerifing = false;

                                                  void startTimer() {
                                                    countDown = 30;
                                                    timer = Timer.periodic(
                                                        const Duration(
                                                            seconds: 1),
                                                        (Timer t) {
                                                      setState(() {
                                                        countDown--;
                                                        if (kDebugMode) {
                                                          print(countDown);
                                                        }
                                                        if (countDown == 0) {
                                                          t.cancel();
                                                          canResend = true;
                                                        }
                                                      });
                                                    });
                                                  }

                                                  startTimer();

                                                  return StatefulBuilder(
                                                    builder:
                                                        (context, setState) {
                                                      try {
                                                        timer2 = Timer.periodic(
                                                            const Duration(
                                                                seconds: 30),
                                                            (Timer t) {
                                                          try {
                                                            setState(() {});
                                                          } catch (e) {
                                                            if (kDebugMode) {
                                                              print(
                                                                  e.toString());
                                                            }
                                                          }
                                                        });
                                                      } catch (e) {
                                                        if (kDebugMode) {
                                                          print(e.toString);
                                                        }
                                                      }
                                                      return AlertDialog(
                                                        title: const Align(
                                                          alignment: Alignment
                                                              .topCenter,
                                                          child: Text(
                                                            'The OTP Sent on Email',
                                                            style: TextStyle(
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                        content: SizedBox(
                                                          height: 130,
                                                          child: Column(
                                                            children: [
                                                              TextField(
                                                                controller:
                                                                    inputCode,
                                                                decoration:
                                                                    const InputDecoration(
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .black,
                                                                        width:
                                                                            0.5),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10)),
                                                                  ),
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .black,
                                                                        width:
                                                                            0.5),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10)),
                                                                  ),
                                                                  hintText:
                                                                      "Enter OTP",
                                                                ),
                                                                onChanged:
                                                                    (value) {
                                                                  errorText =
                                                                      '';
                                                                  setState(
                                                                      () {});
                                                                },
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        4.0),
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                  child: Text(
                                                                    errorText,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red,
                                                                        fontSize:
                                                                            13 /
                                                                                scaleFactor),
                                                                  ),
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  canResend
                                                                      ? TextButton(
                                                                          onPressed:
                                                                              () async {
                                                                            setState(() {
                                                                              canResend = false;
                                                                              startTimer();
                                                                            });
                                                                            code =
                                                                                rng.nextInt(9000) + 1000;
                                                                            await _sendOTPToEmail(code);
                                                                          },
                                                                          child:
                                                                              const Text(
                                                                            'Resend',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.blue,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : const Text(
                                                                          'Resend ',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                        ),
                                                                  ElevatedButton(
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      backgroundColor: const Color
                                                                          .fromRGBO(
                                                                          139,
                                                                          0,
                                                                          0,
                                                                          1),
                                                                    ),
                                                                    child: emailVerifing
                                                                        ? const SizedBox(
                                                                            height:
                                                                                11,
                                                                            width:
                                                                                11,
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              color: Colors.white,
                                                                            ),
                                                                          )
                                                                        : Text('Verify',
                                                                            style: TextStyle(
                                                                              fontSize: 14 / scaleFactor,
                                                                            )),
                                                                    onPressed:
                                                                        () async {
                                                                      if (inputCode
                                                                              .text ==
                                                                          code.toString()) {
                                                                        _emailStatus =
                                                                            'Verified';
                                                                        _tempEmail =
                                                                            _email.text;
                                                                        emailVerifing =
                                                                            true;
                                                                        timer2!
                                                                            .cancel();
                                                                        timer!
                                                                            .cancel();
                                                                        setState(
                                                                            () {});
                                                                        await _updateEmailVerification();
                                                                        emailVerifing =
                                                                            false;

                                                                        Navigator.pop(
                                                                            bContext);
                                                                        setState(
                                                                            () {});
                                                                      } else {
                                                                        errorText =
                                                                            'Invalid OTP';
                                                                        setState(
                                                                            () {});
                                                                      }
                                                                    },
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              ).then((value) {
                                                timer2!.cancel();
                                                timer!.cancel();
                                              });
                                            },
                                      child: Text(
                                        _emailStatus,
                                        style: TextStyle(
                                          fontSize: 14 / scaleFactor,
                                          color: _emailStatus == 'Verify'
                                              ? Colors.black
                                              : Colors.green,
                                        ),
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side:
                              const BorderSide(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 10,
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, bottom: 10, right: 20),
                          child: Wrap(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.phone_android,
                                    color: Colors.grey[400],
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        'Mobile',
                                        style: TextStyle(
                                            decoration: TextDecoration.none,
                                            color: Colors.grey[400],
                                            fontSize: 15 / scaleFactor),
                                      ))
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 5),
                                      child: TextField(
                                        controller: _mobile,
                                        enabled: false,
                                        decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14 / scaleFactor),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                                    borderSide:
                                                        BorderSide(
                                                            color: Colors.grey,
                                                            width: 0.5),
                                                    borderRadius: BorderRadius
                                                        .all(
                                                            Radius
                                                                .circular(10))),
                                            border: InputBorder.none,
                                            focusedBorder:
                                                const OutlineInputBorder(
                                                    borderSide:
                                                        BorderSide(
                                                            color: Colors.grey,
                                                            width: 0.5),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                            labelStyle: TextStyle(
                                              fontSize: 17 / scaleFactor,
                                              color: Colors.black,
                                            ),
                                            fillColor: Colors.white,
                                            filled: true),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        obscureText: false,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Verified",
                                    style: TextStyle(
                                      fontSize: 14 / scaleFactor,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side:
                              const BorderSide(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 10,
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, bottom: 10, right: 20),
                          child: Wrap(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.phone_android,
                                    color: Colors.grey[400],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      'Emergency Mobile',
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: Colors.grey[400],
                                          fontSize: 15 / scaleFactor),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 5),
                                      child: TextField(
                                        enabled: _eSatatus != 'Verified',
                                        controller: _emergency_mobile,
                                        decoration: InputDecoration(
                                          hintStyle: TextStyle(
                                              fontSize: 14 / scaleFactor,
                                              color: Colors.grey),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey,
                                                      width: 0.5),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey[200]!,
                                                  width: 0.5),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10))),
                                          labelStyle: TextStyle(
                                            fontSize: 17 / scaleFactor,
                                            color: Colors.black,
                                          ),
                                          fillColor: Colors.white,
                                          filled: true,
                                        ),
                                        keyboardType: TextInputType.number,
                                        obscureText: false,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  GestureDetector(
                                      onTap: _isDialogShown
                                          ? null
                                          : () async {
                                              if (_eSatatus == 'Verified')
                                                return;
                                              if (_emergency_mobile
                                                      .text.length !=
                                                  10) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            'Enter a valid mobile')));
                                                return;
                                              }
                                              if (_emergency_mobile.text ==
                                                  _mobile.text) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            'Emergency number cannot be same as mobile number')));
                                                return;
                                              }
                                              var rng = Random();
                                              var code =
                                                  rng.nextInt(9000) + 1000;
                                              //print(code);
                                              _isDialogShown = true;
                                              setState(() {});
                                              await _sendOTPToPhone(code);
                                              _isDialogShown = false;
                                              setState(() {});
                                              Timer? timer2;
                                              Timer? timer;
                                              showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (bContext) {
                                                  var inputCode =
                                                      TextEditingController();
                                                  var errorText = '';
                                                  int countDown = 30;
                                                  bool canResend = false;
                                                  bool emailVerifing = false;

                                                  void startTimer() {
                                                    countDown = 30;
                                                    timer = Timer.periodic(
                                                        const Duration(
                                                            seconds: 1),
                                                        (Timer t) {
                                                      setState(() {
                                                        countDown--;
                                                        if (kDebugMode) {
                                                          print(countDown);
                                                        }
                                                        if (countDown == 0) {
                                                          t.cancel();
                                                          canResend = true;
                                                        }
                                                      });
                                                    });
                                                  }

                                                  startTimer();

                                                  return StatefulBuilder(
                                                    builder:
                                                        (context, setState) {
                                                      try {
                                                        timer2 = Timer.periodic(
                                                            const Duration(
                                                                seconds: 30),
                                                            (Timer t) {
                                                          try {
                                                            setState(() {});
                                                          } catch (e) {
                                                            if (kDebugMode) {
                                                              print(
                                                                  e.toString());
                                                            }
                                                          }
                                                        });
                                                      } catch (e) {
                                                        if (kDebugMode) {
                                                          print(e.toString);
                                                        }
                                                      }
                                                      return AlertDialog(
                                                        title: const Align(
                                                          alignment: Alignment
                                                              .topCenter,
                                                          child: Text(
                                                            'The OTP Sent on Number',
                                                            style: TextStyle(
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                        content: SizedBox(
                                                          height: 130,
                                                          child: Column(
                                                            children: [
                                                              TextField(
                                                                controller:
                                                                    inputCode,
                                                                decoration:
                                                                    const InputDecoration(
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .black,
                                                                        width:
                                                                            0.5),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10)),
                                                                  ),
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .black,
                                                                        width:
                                                                            0.5),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10)),
                                                                  ),
                                                                  hintText:
                                                                      "Enter OTP",
                                                                ),
                                                                onChanged:
                                                                    (value) {
                                                                  errorText =
                                                                      '';
                                                                  setState(
                                                                      () {});
                                                                },
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        4.0),
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                  child: Text(
                                                                    errorText,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red,
                                                                        fontSize:
                                                                            13 /
                                                                                scaleFactor),
                                                                  ),
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  canResend
                                                                      ? TextButton(
                                                                          onPressed:
                                                                              () async {
                                                                            setState(() {
                                                                              canResend = false;
                                                                              startTimer();
                                                                            });
                                                                            code =
                                                                                rng.nextInt(9000) + 1000;
                                                                            await _sendOTPToPhone(code);
                                                                          },
                                                                          child:
                                                                              const Text(
                                                                            'Resend',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.blue,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : const Text(
                                                                          'Resend ',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                        ),
                                                                  ElevatedButton(
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      backgroundColor: const Color
                                                                          .fromRGBO(
                                                                          139,
                                                                          0,
                                                                          0,
                                                                          1),
                                                                    ),
                                                                    child: emailVerifing
                                                                        ? const SizedBox(
                                                                            height:
                                                                                11,
                                                                            width:
                                                                                11,
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              color: Colors.white,
                                                                            ),
                                                                          )
                                                                        : Text('Verify',
                                                                            style: TextStyle(
                                                                              fontSize: 14 / scaleFactor,
                                                                            )),
                                                                    onPressed:
                                                                        () async {
                                                                      if (inputCode
                                                                              .text ==
                                                                          code.toString()) {
                                                                        _eSatatus =
                                                                            'Verified';
                                                                        _tempEmergencyMobile =
                                                                            _emergency_mobile.text;
                                                                        emailVerifing =
                                                                            true;
                                                                        timer2!
                                                                            .cancel();
                                                                        timer!
                                                                            .cancel();
                                                                        setState(
                                                                            () {});
                                                                        await _updateENumberVerification();
                                                                        emailVerifing =
                                                                            false;

                                                                        Navigator.pop(
                                                                            bContext);
                                                                        setState(
                                                                            () {});
                                                                      } else {
                                                                        errorText =
                                                                            'Invalid OTP';
                                                                        setState(
                                                                            () {});
                                                                      }
                                                                    },
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              ).then((value) {
                                                timer2!.cancel();
                                                timer!.cancel();
                                              });
                                            },
                                      child: Text(
                                        _eSatatus,
                                        style: TextStyle(
                                          fontSize: 14 / scaleFactor,
                                          color: _eSatatus == 'Verify'
                                              ? Colors.black
                                              : Colors.green,
                                        ),
                                      ))
                                ],
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Directionality(
                                            textDirection: TextDirection.ltr,
                                            child: TextField(
                                              enabled: _relationName == "",
                                              textAlign: TextAlign.left,
                                              controller:
                                                  _relationNameController,
                                              decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                      fontSize:
                                                          14 / scaleFactor,
                                                      color: Colors.grey),
                                                  hintStyle: TextStyle(
                                                      fontSize:
                                                          14 / scaleFactor,
                                                      color: Colors.grey),
                                                  enabledBorder: const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.grey,
                                                          width: 0.5),
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(10))),
                                                  border: InputBorder.none,
                                                  focusedBorder:
                                                      const OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color:
                                                                  Colors.grey,
                                                              width: 0.5),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      10))),
                                                  labelText: " Name",
                                                  hintText:
                                                      "Enter name of number owner"),
                                            ))),
                                  ),
                                  // Flexible(
                                  //   child: Padding(
                                  //       padding: EdgeInsets.all(10),
                                  //       child: Directionality(
                                  //           textDirection: TextDirection.ltr,
                                  //           child: TextField(
                                  //             controller: _cu,
                                  //
                                  //             textAlign: TextAlign.left,
                                  //             decoration:
                                  //             InputDecoration(
                                  //                 labelStyle: TextStyle(
                                  //                     color: Colors.grey),
                                  //                 hintStyle: TextStyle(color: Colors.black),
                                  //                 enabledBorder: OutlineInputBorder(
                                  //                     borderSide: BorderSide(color: Colors.grey,width: 0.5),
                                  //                     borderRadius: BorderRadius.all(Radius.circular(10))
                                  //                 ),
                                  //                 border: InputBorder.none,
                                  //                 focusedBorder: OutlineInputBorder(
                                  //                     borderSide: BorderSide(color: Colors.grey,width: 0.5),
                                  //                     borderRadius: BorderRadius.all(Radius.circular(10))
                                  //
                                  //                 ),
                                  //                 labelText: "Zip code",
                                  //                 hintText: "00000000000000"
                                  //             ),
                                  //           )
                                  //       )
                                  //   ),
                                  // ),
                                ],
                              ),
                              isDisabled
                                  ? Row(
                                      children: [
                                        Flexible(
                                          child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Directionality(
                                                  textDirection:
                                                      TextDirection.ltr,
                                                  child: TextField(
                                                    enabled: false,
                                                    textAlign: TextAlign.left,
                                                    controller:
                                                        _relationController,
                                                    decoration: InputDecoration(
                                                        labelStyle: TextStyle(
                                                            fontSize: 14 /
                                                                scaleFactor,
                                                            color: Colors.grey),
                                                        hintStyle: TextStyle(
                                                            fontSize: 14 /
                                                                scaleFactor,
                                                            color: Colors.grey),
                                                        enabledBorder: const OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color:
                                                                    Colors.grey,
                                                                width: 0.5),
                                                            borderRadius: BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                        border:
                                                            InputBorder.none,
                                                        focusedBorder: const OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color:
                                                                    Colors.grey,
                                                                width: 0.5),
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(10))),
                                                        labelText: " Relation",
                                                        hintText: "Enter name of number owner"),
                                                  ))),
                                        ),
                                        // Flexible(
                                        //   child: Padding(
                                        //       padding: EdgeInsets.all(10),
                                        //       child: Directionality(
                                        //           textDirection: TextDirection.ltr,
                                        //           child: TextField(
                                        //             controller: _cu,
                                        //
                                        //             textAlign: TextAlign.left,
                                        //             decoration:
                                        //             InputDecoration(
                                        //                 labelStyle: TextStyle(
                                        //                     color: Colors.grey),
                                        //                 hintStyle: TextStyle(color: Colors.black),
                                        //                 enabledBorder: OutlineInputBorder(
                                        //                     borderSide: BorderSide(color: Colors.grey,width: 0.5),
                                        //                     borderRadius: BorderRadius.all(Radius.circular(10))
                                        //                 ),
                                        //                 border: InputBorder.none,
                                        //                 focusedBorder: OutlineInputBorder(
                                        //                     borderSide: BorderSide(color: Colors.grey,width: 0.5),
                                        //                     borderRadius: BorderRadius.all(Radius.circular(10))
                                        //
                                        //                 ),
                                        //                 labelText: "Zip code",
                                        //                 hintText: "00000000000000"
                                        //             ),
                                        //           )
                                        //       )
                                        //   ),
                                        // ),
                                      ],
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(13.0),
                                      child: DropdownButton<String>(
                                        hint: const Text("Select the relation"),
                                        value: selectedRelation,
                                        isExpanded: true,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedRelation = newValue;
                                          });
                                        },
                                        items: relation
                                            .map<DropdownMenuItem<String>>(
                                          (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value,
                                                  style: TextStyle(
                                                      fontSize:
                                                          14 / scaleFactor)),
                                            );
                                          },
                                        ).toList(),
                                      ),
                                    ),
                              /*  Flexible(
                                 child: Padding(
                                   padding: const EdgeInsets.all(10.0),
                                   child: Row(
                                    children: [
                                      DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          value: selectedRelation,
                                          isExpanded: true,
                                          hint: const Text("Select relation"),
                                          items: relation.map((valueItem) {
                                            return DropdownMenuItem<String>(
                                              value: valueItem,
                                              child: Text(valueItem),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedRelation = newValue!;
                                            });
                                          },
                                          buttonStyleData:  ButtonStyleData(decoration: BoxDecoration(

                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Colors.grey,
                                                  width: 0.5
                                              )

                                          ),

                                          ),
                                        ),
                                      ),

*/ /*
                                      Flexible(
                                        child: Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Directionality(
                                                textDirection: TextDirection.ltr,
                                                child: TextField(
                                                  //enabled: addressEditable,
                                                  textAlign: TextAlign.left,
                                                  // controller: _currentHouse,
                                                  decoration: InputDecoration(
                                                      labelStyle: TextStyle(
                                                          color: Colors.grey),
                                                      hintStyle: TextStyle(
                                                          color: Colors.grey),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors.grey,
                                                              width: 0.5),
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                      border: InputBorder.none,
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors.grey,
                                                              width: 0.5),
                                                          borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                      labelText: " Relation",
                                                      hintText:
                                                      "Select your Relation"),
                                                ))),
                                      ),
*/ /*
                                    ],
                              ),
                                 ),
                               ),*/
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      //  Card(
                      //   color: Colors.white,
                      //   shape: RoundedRectangleBorder(
                      //     side: BorderSide(color: Colors.grey, width: 0.5),
                      //     borderRadius: BorderRadius.circular(10.0),
                      //   ),
                      //   elevation: 10,
                      //   margin:EdgeInsets.only(left: 10,right:10),
                      //   child: Container(
                      //     padding: EdgeInsets.only(top: 10,left: 30,bottom: 10,right: 20),
                      //     child: Wrap(
                      //       children: [
                      //         Row(children: [Icon(Icons.house_rounded,color: Colors.grey[400],),Padding(padding:EdgeInsets.only(left: 10),child: Text('House Number',style: TextStyle( decoration: TextDecoration.underline,color: Colors.grey[400],fontSize: 15),))],),
                      //
                      //         Container(
                      //           margin: EdgeInsets.only(top: 5),
                      //           child: TextField(
                      //             controller: _currentHouse,
                      //             decoration: InputDecoration(
                      //                 hintStyle: TextStyle(color: Colors.grey),
                      //                 enabledBorder: OutlineInputBorder(
                      //                     borderSide: BorderSide(color: Colors.white,width: 0.5),
                      //                     borderRadius: BorderRadius.all(Radius.circular(10))
                      //                 ),
                      //                 border: InputBorder.none,
                      //                 focusedBorder: OutlineInputBorder(
                      //                     borderSide: BorderSide(color: Colors.grey[200]!,width: 0.5),
                      //                     borderRadius: BorderRadius.all(Radius.circular(10))
                      //
                      //                 ),
                      //                 labelStyle: TextStyle(
                      //                   fontSize: 17,
                      //                   color: Colors.black,
                      //                 ),
                      //                 fillColor: Colors.white,
                      //                 filled: true
                      //             ),
                      //             keyboardType: TextInputType.emailAddress,
                      //             obscureText: false,
                      //
                      //           ),
                      //         ),
                      //
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      //
                      //  SizedBox(height: 10,),
                      //  Card(
                      //   color: Colors.white,
                      //   shape: RoundedRectangleBorder(
                      //     side: BorderSide(color: Colors.grey, width: 0.5),
                      //     borderRadius: BorderRadius.circular(10.0),
                      //   ),
                      //   elevation: 10,
                      //   margin:EdgeInsets.only(left: 10,right:10),
                      //   child: Container(
                      //     padding: EdgeInsets.only(top: 10,left: 30,bottom: 10,right: 20),
                      //     child: Wrap(
                      //       children: [
                      //         Row(children: [Icon(Icons.house_rounded,color: Colors.grey[400],),Padding(padding:EdgeInsets.only(left: 10),child: Text('Area',style: TextStyle( decoration: TextDecoration.underline,color: Colors.grey[400],fontSize: 15),))],),
                      //
                      //         Container(
                      //           margin: EdgeInsets.only(top: 5),
                      //           child: TextField(
                      //             controller: _currentArea,
                      //             decoration: InputDecoration(
                      //                 hintStyle: TextStyle(color: Colors.grey),
                      //                 enabledBorder: OutlineInputBorder(
                      //                     borderSide: BorderSide(color: Colors.white,width: 0.5),
                      //                     borderRadius: BorderRadius.all(Radius.circular(10))
                      //                 ),
                      //                 border: InputBorder.none,
                      //                 focusedBorder: OutlineInputBorder(
                      //                     borderSide: BorderSide(color: Colors.grey[200]!,width: 0.5),
                      //                     borderRadius: BorderRadius.all(Radius.circular(10))
                      //
                      //                 ),
                      //                 labelStyle: TextStyle(
                      //                   fontSize: 17,
                      //                   color: Colors.black,
                      //                 ),
                      //                 fillColor: Colors.white,
                      //                 filled: true
                      //             ),
                      //             keyboardType: TextInputType.emailAddress,
                      //             obscureText: false,
                      //
                      //           ),
                      //         ),
                      //
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      //
                      //  SizedBox(height: 10,),
                      //  Card(
                      //   color: Colors.white,
                      //   shape: RoundedRectangleBorder(
                      //     side: BorderSide(color: Colors.grey, width: 0.5),
                      //     borderRadius: BorderRadius.circular(10.0),
                      //   ),
                      //   elevation: 10,
                      //   margin:EdgeInsets.only(left: 10,right:10),
                      //   child: Container(
                      //     padding: EdgeInsets.only(top: 10,left: 30,bottom: 10,right: 20),
                      //     child: Wrap(
                      //       children: [
                      //         Row(children: [Icon(Icons.house_rounded,color: Colors.grey[400],),Padding(padding:EdgeInsets.only(left: 10),child: Text('Landmark',style: TextStyle( decoration: TextDecoration.underline,color: Colors.grey[400],fontSize: 15),))],),
                      //
                      //         Container(
                      //           margin: EdgeInsets.only(top: 5),
                      //           child: TextField(
                      //             controller: _currentLandmark,
                      //             decoration: InputDecoration(
                      //                 hintStyle: TextStyle(color: Colors.grey),
                      //                 enabledBorder: OutlineInputBorder(
                      //                     borderSide: BorderSide(color: Colors.white,width: 0.5),
                      //                     borderRadius: BorderRadius.all(Radius.circular(10))
                      //                 ),
                      //                 border: InputBorder.none,
                      //                 focusedBorder: OutlineInputBorder(
                      //                     borderSide: BorderSide(color: Colors.grey[200]!,width: 0.5),
                      //                     borderRadius: BorderRadius.all(Radius.circular(10))
                      //
                      //                 ),
                      //                 labelStyle: TextStyle(
                      //                   fontSize: 17,
                      //                   color: Colors.black,
                      //                 ),
                      //                 fillColor: Colors.white,
                      //                 filled: true
                      //             ),
                      //             keyboardType: TextInputType.emailAddress,
                      //             obscureText: false,
                      //
                      //           ),
                      //         ),
                      //
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      //
                      //  SizedBox(height: 10,),
                      //  Card(
                      //   color: Colors.white,
                      //   shape: RoundedRectangleBorder(
                      //     side: BorderSide(color: Colors.grey, width: 0.5),
                      //     borderRadius: BorderRadius.circular(10.0),
                      //   ),
                      //   elevation: 10,
                      //   margin:EdgeInsets.only(left: 10,right:10),
                      //   child: Container(
                      //     padding: EdgeInsets.only(top: 10,left: 30,bottom: 10,right: 20),
                      //     child: Wrap(
                      //       children: [
                      //         Row(children: [Icon(Icons.house_rounded,color: Colors.grey[400],),Padding(padding:EdgeInsets.only(left: 10),child: Text('City',style: TextStyle( decoration: TextDecoration.underline,color: Colors.grey[400],fontSize: 15),))],),
                      //
                      //         Container(
                      //           margin: EdgeInsets.only(top: 5),
                      //           child: TextField(
                      //             controller: _currentCity,
                      //             decoration: InputDecoration(
                      //                 hintStyle: TextStyle(color: Colors.grey),
                      //                 enabledBorder: OutlineInputBorder(
                      //                     borderSide: BorderSide(color: Colors.white,width: 0.5),
                      //                     borderRadius: BorderRadius.all(Radius.circular(10))
                      //                 ),
                      //                 border: InputBorder.none,
                      //                 focusedBorder: OutlineInputBorder(
                      //                     borderSide: BorderSide(color: Colors.grey[200]!,width: 0.5),
                      //                     borderRadius: BorderRadius.all(Radius.circular(10))
                      //
                      //                 ),
                      //                 labelStyle: TextStyle(
                      //                   fontSize: 17,
                      //                   color: Colors.black,
                      //                 ),
                      //                 fillColor: Colors.white,
                      //                 filled: true
                      //             ),
                      //             keyboardType: TextInputType.emailAddress,
                      //             obscureText: false,
                      //
                      //           ),
                      //         ),
                      //
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      //
                      // SizedBox(height: 10,),
                      // Card(
                      //   color: Colors.white,
                      //   shape: RoundedRectangleBorder(
                      //     side: BorderSide(color: Colors.grey, width: 0.5),
                      //     borderRadius: BorderRadius.circular(10.0),
                      //   ),
                      //   elevation: 10,
                      //   margin:EdgeInsets.only(left: 10,right:10),
                      //   child: Container(
                      //     padding: EdgeInsets.only(top: 10,left: 30,bottom: 10,right: 20),
                      //     child: Wrap(
                      //       children: [
                      //         Row(children: [Icon(Icons.house_rounded,color: Colors.grey[400],),Padding(padding:EdgeInsets.only(left: 10),child: Text('House Number',style: TextStyle( decoration: TextDecoration.underline,color: Colors.grey[400],fontSize: 15),))],),
                      //
                      //         Container(
                      //           margin: EdgeInsets.only(top: 5),
                      //           child: TextField(
                      //             controller: _permanentHouse,
                      //             decoration: InputDecoration(
                      //                 hintStyle: TextStyle(color: Colors.grey),
                      //                 enabledBorder: OutlineInputBorder(
                      //                     borderSide: BorderSide(color: Colors.white,width: 0.5),
                      //                     borderRadius: BorderRadius.all(Radius.circular(10))
                      //                 ),
                      //                 border: InputBorder.none,
                      //                 focusedBorder: OutlineInputBorder(
                      //                     borderSide: BorderSide(color: Colors.grey[200]!,width: 0.5),
                      //                     borderRadius: BorderRadius.all(Radius.circular(10))
                      //
                      //                 ),
                      //                 labelStyle: TextStyle(
                      //                   fontSize: 17,
                      //                   color: Colors.black,
                      //                 ),
                      //                 fillColor: Colors.white,
                      //                 filled: true
                      //             ),
                      //             keyboardType: TextInputType.emailAddress,
                      //             obscureText: false,
                      //
                      //           ),
                      //         ),
                      //
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      //
                      // SizedBox(height: 10,),
                      // Card(
                      //   color: Colors.white,
                      //   shape: RoundedRectangleBorder(
                      //     side: BorderSide(color: Colors.grey, width: 0.5),
                      //     borderRadius: BorderRadius.circular(10.0),
                      //   ),
                      //   elevation: 10,
                      //   margin:EdgeInsets.only(left: 10,right:10),
                      //   child: Container(
                      //     padding: EdgeInsets.only(top: 10,left: 30,bottom: 10,right: 20),
                      //     child: Wrap(
                      //       children: [
                      //         Row(children: [Icon(Icons.house_rounded,color: Colors.grey[400],),Padding(padding:EdgeInsets.only(left: 10),child: Text('Area',style: TextStyle( decoration: TextDecoration.underline,color: Colors.grey[400],fontSize: 15),))],),
                      //
                      //         Container(
                      //           margin: EdgeInsets.only(top: 5),
                      //           child: TextField(
                      //             controller: _permanentArea,
                      //             decoration: InputDecoration(
                      //                 hintStyle: TextStyle(color: Colors.grey),
                      //                 enabledBorder: OutlineInputBorder(
                      //                     borderSide: BorderSide(color: Colors.white,width: 0.5),
                      //                     borderRadius: BorderRadius.all(Radius.circular(10))
                      //                 ),
                      //                 border: InputBorder.none,
                      //                 focusedBorder: OutlineInputBorder(
                      //                     borderSide: BorderSide(color: Colors.grey[200]!,width: 0.5),
                      //                     borderRadius: BorderRadius.all(Radius.circular(10))
                      //
                      //                 ),
                      //                 labelStyle: TextStyle(
                      //                   fontSize: 17,
                      //                   color: Colors.black,
                      //                 ),
                      //                 fillColor: Colors.white,
                      //                 filled: true
                      //             ),
                      //             keyboardType: TextInputType.emailAddress,
                      //             obscureText: false,
                      //
                      //           ),
                      //         ),
                      //
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      //
                      // SizedBox(height: 10,),
                      // Card(
                      //   color: Colors.white,
                      //   shape: RoundedRectangleBorder(
                      //     side: BorderSide(color: Colors.grey, width: 0.5),
                      //     borderRadius: BorderRadius.circular(10.0),
                      //   ),
                      //   elevation: 10,
                      //   margin:EdgeInsets.only(left: 10,right:10),
                      //   child: Container(
                      //     padding: EdgeInsets.only(top: 10,left: 30,bottom: 10,right: 20),
                      //     child: Wrap(
                      //       children: [
                      //         Row(children: [Icon(Icons.house_rounded,color: Colors.grey[400],),Padding(padding:EdgeInsets.only(left: 10),child: Text('Landmark',style: TextStyle( decoration: TextDecoration.underline,color: Colors.grey[400],fontSize: 15),))],),
                      //
                      //         Container(
                      //           margin: EdgeInsets.only(top: 5),
                      //           child: TextField(
                      //             controller: _permanentLandmark,
                      //             decoration: InputDecoration(
                      //                 hintStyle: TextStyle(color: Colors.grey),
                      //                 enabledBorder: OutlineInputBorder(
                      //                     borderSide: BorderSide(color: Colors.white,width: 0.5),
                      //                     borderRadius: BorderRadius.all(Radius.circular(10))
                      //                 ),
                      //                 border: InputBorder.none,
                      //                 focusedBorder: OutlineInputBorder(
                      //                     borderSide: BorderSide(color: Colors.grey[200]!,width: 0.5),
                      //                     borderRadius: BorderRadius.all(Radius.circular(10))
                      //
                      //                 ),
                      //                 labelStyle: TextStyle(
                      //                   fontSize: 17,
                      //                   color: Colors.black,
                      //                 ),
                      //                 fillColor: Colors.white,
                      //                 filled: true
                      //             ),
                      //             keyboardType: TextInputType.emailAddress,
                      //             obscureText: false,
                      //
                      //           ),
                      //         ),
                      //
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      //
                      // SizedBox(height: 10,),
                      // Card(
                      //   color: Colors.white,
                      //   shape: RoundedRectangleBorder(
                      //     side: BorderSide(color: Colors.grey, width: 0.5),
                      //     borderRadius: BorderRadius.circular(10.0),
                      //   ),
                      //   elevation: 10,
                      //   margin:EdgeInsets.only(left: 10,right:10),
                      //   child: Container(
                      //     padding: EdgeInsets.only(top: 10,left: 30,bottom: 10,right: 20),
                      //     child: Wrap(
                      //       children: [
                      //         Row(children: [Icon(Icons.house_rounded,color: Colors.grey[400],),Padding(padding:EdgeInsets.only(left: 10),child: Text('City',style: TextStyle( decoration: TextDecoration.underline,color: Colors.grey[400],fontSize: 15),))],),
                      //
                      //         Container(
                      //           margin: EdgeInsets.only(top: 5),
                      //           child: TextField(
                      //             controller: _permanentCity,
                      //             decoration: InputDecoration(
                      //                 hintStyle: TextStyle(color: Colors.grey),
                      //                 enabledBorder: OutlineInputBorder(
                      //                     borderSide: BorderSide(color: Colors.white,width: 0.5),
                      //                     borderRadius: BorderRadius.all(Radius.circular(10))
                      //                 ),
                      //                 border: InputBorder.none,
                      //                 focusedBorder: OutlineInputBorder(
                      //                     borderSide: BorderSide(color: Colors.grey[200]!,width: 0.5),
                      //                     borderRadius: BorderRadius.all(Radius.circular(10))
                      //
                      //                 ),
                      //                 labelStyle: TextStyle(
                      //                   fontSize: 17,
                      //                   color: Colors.black,
                      //                 ),
                      //                 fillColor: Colors.white,
                      //                 filled: true
                      //             ),
                      //             keyboardType: TextInputType.emailAddress,
                      //             obscureText: false,
                      //
                      //           ),
                      //         ),
                      //
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Colors.grey, width: 0.5),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 10,
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Wrap(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.grey[400],
                                    ),
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          'Current Address',
                                          style: TextStyle(
                                              decoration: TextDecoration.none,
                                              color: Colors.grey[400],
                                              fontSize: 15 / scaleFactor),
                                        ))
                                  ],
                                ),
                                const SizedBox(height: 25),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Directionality(
                                              textDirection: TextDirection.ltr,
                                              child: TextField(
                                                enabled: addressEditable,
                                                textAlign: TextAlign.left,
                                                controller: _currentHouse,
                                                decoration: InputDecoration(
                                                    labelStyle: TextStyle(
                                                        fontSize:
                                                            14 / scaleFactor,
                                                        color: Colors.grey),
                                                    hintStyle: TextStyle(
                                                        fontSize:
                                                            14 / scaleFactor,
                                                        color: Colors.grey),
                                                    enabledBorder: const OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.grey,
                                                            width: 0.5),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                    border: InputBorder.none,
                                                    focusedBorder: const OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.grey,
                                                            width: 0.5),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                    labelText: " House Number",
                                                    hintText: "Enter House Number"),
                                              ))),
                                    ),
                                  ],
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: TextField(
                                          enabled: addressEditable,
                                          controller: _currentArea,
                                          textAlign: TextAlign.left,
                                          decoration: InputDecoration(
                                              labelStyle: TextStyle(
                                                  fontSize: 14 / scaleFactor,
                                                  color: Colors.grey),
                                              hintStyle: TextStyle(
                                                  fontSize: 14 / scaleFactor,
                                                  color: Colors.grey),
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.grey,
                                                          width: 0.5),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                              border: InputBorder.none,
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.grey,
                                                          width: 0.5),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                              labelText: "Area",
                                              hintText: "Enter Area"),
                                        ))),
                                Center(
                                  child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: TextField(
                                            enabled: addressEditable,
                                            controller: _currentLandmark,
                                            textAlign: TextAlign.left,
                                            decoration: InputDecoration(
                                                labelStyle: TextStyle(
                                                    fontSize: 14 / scaleFactor,
                                                    color: Colors.grey),
                                                hintStyle: TextStyle(
                                                    fontSize: 14 / scaleFactor,
                                                    color: Colors.grey),
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.grey,
                                                            width: 0.5),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                border: InputBorder.none,
                                                focusedBorder:
                                                    const OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.grey,
                                                            width: 0.5),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                labelText: " Landmark",
                                                hintText: "Enter Landmark"),
                                          ))),
                                ),
                                Center(
                                  child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: TextField(
                                            controller: _currentCity,
                                            enabled: addressEditable,
                                            textAlign: TextAlign.left,
                                            decoration: InputDecoration(
                                                labelStyle: TextStyle(
                                                    fontSize: 14 / scaleFactor,
                                                    color: Colors.grey),
                                                hintStyle: TextStyle(
                                                    fontSize: 14 / scaleFactor,
                                                    color: Colors.grey),
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.grey,
                                                            width: 0.5),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                border: InputBorder.none,
                                                focusedBorder:
                                                    const OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.grey,
                                                            width: 0.5),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                labelText: " City",
                                                hintText: "Enter Your City"),
                                          ))),
                                ),
                              ],
                            ),
                          )),

                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            errorText,
                            style: TextStyle(
                                fontSize: 12 / scaleFactor,
                                color: Colors.red,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),

                      InkWell(
                        onTap: () async {
                          _uploadDetails();
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
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _pb
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          "Save & Continue",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
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
                Padding(
                    padding:
                        const EdgeInsets.only(top: 50, right: 20, left: 20),
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 10,
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 20),
                        width: MediaQuery.of(context).size.width,
                        height: 130,
                        child:
                            Stack(alignment: Alignment.bottomCenter, children: [
                          Center(
                            child: Text(
                              _customerName,
                              style: TextStyle(
                                  fontSize: 14 / scaleFactor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            'Account Details',
                            style: TextStyle(
                                fontSize: 25 / scaleFactor,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[400]),
                          )
                        ]),
                      ),
                    )),
                Container(
                  alignment: Alignment.topCenter,
                  // margin: EdgeInsets.only(top: 10),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext bcontext) {
                            return AlertDialog(
                                title: Text(
                                    "From where do you want to take the photo?",
                                    style:
                                        TextStyle(fontSize: 14 / scaleFactor)),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      const Padding(
                                          padding: EdgeInsets.all(8.0)),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          child: Text("Camera",
                                              style: TextStyle(
                                                  fontSize: 14 / scaleFactor)),
                                          onTap: () async {
                                            _profileImage = await ImagePicker()
                                                .pickImage(
                                                    source: ImageSource.camera);
                                            Navigator.pop(bcontext);
                                            setState(() {});
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ));
                          });
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _profileImage != null
                          ? Image.file(File(_profileImage!.path)).image
                          : _profile != "-"
                              ? NetworkImage(_profile)
                              : null,
                      child: _profileImage == null && _profile == "-" ||
                              _profile == ""
                          ? const Icon(Icons.camera_alt_outlined,
                              color: Colors.black)
                          : null,

                      // child: Padding(
                      //   padding:  EdgeInsets.all(8), // Border radius
                      //   child: _profileImage==null?Image.network(_profile):Image.file(File(_profileImage!.path),
                      //   ),
                      // ),
                    ),
                  ),
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _getUserDetails() async {
    UserModel temp = ref.read(userProvider)!;
    if (temp.aadhaarFront == "") {
      await ref.read(authControllerProvider.notifier).getUserDetails();
      _getUserDetails();
    } else {
      _name.text = temp.firstname!;
      _tempName = temp.firstname!;
      _customerName = temp.firstname!;
      _tempCustName = temp.firstname!;
      _profile = temp.profileImage!;
      _tempProfile = temp.profileImage!;
      _email.text = temp.email!;
      _tempEmail = temp.email!;
      _emergency_mobile.text = temp.emergencyMobile!;
      _tempEmergencyMobile = temp.emergencyMobile!;
      _mobile.text = temp.mobile!;
      _tempMobile = temp.mobile!;
      mobo = temp.mobile!;
      _currentHouse.text = temp.currentAddressHouse!;
      _tempcurrHouse = temp.currentAddressHouse!;
      _currentArea.text = temp.currentAddressArea!;
      _tempcurrArea = temp.currentAddressArea!;
      _currentLandmark.text = temp.currentAddressLandmark!;
      _tempcurrLand = temp.currentAddressLandmark!;
      _currentCity.text = temp.currentAddressCity!;
      _tempcuuCity = temp.currentAddressCity!;
      _permanentHouse.text = temp.permanentAddressHouse!;
      _tempperHouse = temp.permanentAddressHouse!;
      _permanentArea.text = temp.permanentAddressArea!;
      _tempperArea = temp.permanentAddressArea!;
      _permanentLandmark.text = temp.permanentAddressLandmark!;
      _tempperLand = temp.permanentAddressLandmark!;
      _permanentCity.text = temp.permanentAddressCity!;
      _tempperCity = temp.permanentAddressCity!;
      _relationName = temp.emergencyName!;
      _relationNameController.text = temp.emergencyName!;
      _relationController.text = temp.emergencyRelation!;
      _emailStatus = temp.emailVerified! == '1' ? "Verified" : 'Verify';
      _tempEmailStatus = temp.emailVerified! == '1' ? "Verified" : 'Verify';
      _eSatatus = temp.emergencyMobileVerified! == '1' ? "Verified" : 'Verify';
      _tempesataus =
          temp.emergencyMobileVerified! == '1' ? "Verified" : 'Verify';
      if (_relationController.text != "") {
        selectedRelation = _relationController.text;
        isDisabled = true;
      }
      bool tripCheck =
          await ref.read(moreControllerProvider.notifier).checkTrips(context);

      if (tripCheck) {
        setState(() {
          addressEditable = true;
        });
      }
      if (_currentCity.text.trim() == "" ||
          _currentLandmark.text.trim() == "" ||
          _currentArea.text.trim() == "" ||
          _currentHouse.text.trim() == "") {
        setState(() {
          addressEditable = true;
        });
      }

      setState(() {});
    }
  }

  _updateENumberVerification() async {
    ref.read(userProvider.notifier).update((state) {
      return state!.copyWith(
          emergencyMobileVerified: "1",
          emergencyMobile: _emergency_mobile.text);
    });
    UserModel temp = ref.read(userProvider)!;
    await ref
        .read(moreControllerProvider.notifier)
        .setUserDetails(temp, null, context);
    // setState(() {
    //   _pb = true;
    // });
    // var prefs = await SharedPreferences.getInstance();
    // var token = prefs.getString('token') ?? "";
    // var headers = {'token': token};
    // var request = http.MultipartRequest(
    //     'POST',
    //     Uri.parse(
    //         'https://www.ridobiko.com/android_app_customer/api/setUserDetails.php'));
    // request.fields.addAll({
    //   'name': _tempName,
    //   'email': _tempEmail,
    //   'emergency_no': _emergency_mobile.text,
    //   'employer': ' ',
    //   'profession': ' ',
    //   'email_verified': _emailStatus == 'Verify' ? "0" : '1',
    //   'emobile_verified': '1',
    //   'current_address_house': _tempcurrHouse,
    //   'current_address_area': _tempcurrArea,
    //   'current_address_landmark': _tempcurrLand,
    //   'current_address_city': _tempcuuCity,
    //   'permanent_address_house': _tempperHouse,
    //   'permanent_address_area': _tempperArea,
    //   'permanent_address_landmark': _tempperLand,
    //   'permanent_address_city': _tempperCity,
    // });
    // request.headers.addAll(headers);
    // if (_profileImage != null) {
    //   request.files.add(await http.MultipartFile.fromPath(
    //       'image_profile', _profileImage!.path));
    // }

    // http.StreamedResponse response = await request.send();
    // setState(() {
    //   _pb = false;
    // });
    // var json = jsonDecode(await response.stream.bytesToString());
    // print(json);
  }

  _updateEmailVerification() async {
    ref.read(userProvider.notifier).update((state) {
      return state!.copyWith(emailVerified: "1", email: _email.text.trim());
    });
    UserModel temp = ref.read(userProvider)!;
    await ref
        .read(moreControllerProvider.notifier)
        .setUserDetails(temp, null, context);

    // setState(() {
    //   _pb = true;
    // });
    // var prefs = await SharedPreferences.getInstance();
    // var token = prefs.getString('token') ?? "";
    // var headers = {'token': token};
    // var request = http.MultipartRequest(
    //     'POST',
    //     Uri.parse(
    //         'https://www.ridobiko.com/android_app_customer/api/setUserDetails.php'));
    // request.fields.addAll({
    //   'name': _tempName,
    //   'email': _email.text,
    //   'emergency_no': _tempEmergencyMobile,
    //   'employer': ' ',
    //   'profession': ' ',
    //   'email_verified': '1',
    //   'emobile_verified': _eSatatus == 'Verify' ? "0" : '1',
    //   'current_address_house': _tempcurrHouse,
    //   'current_address_area': _tempcurrArea,
    //   'current_address_landmark': _tempcurrLand,
    //   'current_address_city': _tempcuuCity,
    //   'permanent_address_house': _tempperHouse,
    //   'permanent_address_area': _tempperArea,
    //   'permanent_address_landmark': _tempperLand,
    //   'permanent_address_city': _tempperCity,
    // });
    // request.headers.addAll(headers);
    // if (_profileImage != null) {
    //   request.files.add(await http.MultipartFile.fromPath(
    //       'image_profile', _profileImage!.path));
    // }

    // http.StreamedResponse response = await request.send();
    // setState(() {
    //   _pb = false;
    // });
    // var json = jsonDecode(await response.stream.bytesToString());
    // print(json);
  }

  _uploadDetails() async {
    if (_name.text.trim() == "" ||
        _currentHouse.text.trim() == "" ||
        _currentArea.text.trim() == "" ||
        _currentLandmark.text.trim() == "" ||
        _currentCity.text.trim() == "" ||
        _relationNameController.text.trim() == "" ||
        selectedRelation == null ||
        selectedRelation == "") {
      setState(() {
        errorText = "Please fill all the fields";
      });
    } else if (_emailStatus != 'Verified' || _eSatatus != 'Verified') {
      setState(() {
        errorText = "Please Verify all the credentials";
      });
    } else if (_profile == "-" && _profileImage == null) {
      setState(() {
        errorText = "Please add a profile picture";
      });
    } else {
      setState(() {
        _pb = true;
      });

      ref.read(userProvider.notifier).update((state) {
        return state!.copyWith(
          firstname: _name.text,
          email: _email.text,
          emergencyMobile: _emergency_mobile.text,
          emergencyName: _relationNameController.text,
          emergencyRelation: selectedRelation != null
              ? selectedRelation!
              : _relationController.text,
          emailVerified: _emailStatus == 'Verify' ? "0" : '1',
          emergencyMobileVerified: _eSatatus == 'Verify' ? "0" : '1',
          currentAddressHouse: _currentHouse.text,
          currentAddressArea: _currentArea.text,
          currentAddressLandmark: _currentLandmark.text,
          currentAddressCity: _currentCity.text,
          permanentAddressHouse: _permanentHouse.text,
          permanentAddressArea: _permanentArea.text,
          permanentAddressLandmark: _permanentLandmark.text,
          permanentAddressCity: _permanentCity.text,
        );
      });
      UserModel temp = ref.read(userProvider)!;
      await ref
          .read(moreControllerProvider.notifier)
          .setUserDetails(temp, _profileImage, context);

      setState(() {
        _pb = false;
      });

      Toast(context, "Profile Updated");
      if (BookingFlow.fromMore == false) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const DocUpload()));
      } else {
        Navigator.of(context).pop();
      }

      //   var prefs = await SharedPreferences.getInstance();
      //   var token = prefs.getString('token') ?? "";
      //   var headers = {'token': token};
      //   var request = http.MultipartRequest(
      //       'POST',
      //       Uri.parse(
      //           'https://www.ridobiko.com/android_app_customer/api/setUserDetails.php'));
      //   request.fields.addAll({
      //     'name': _name.text,
      //     'email': _email.text,
      //     'emergency_no': _emergency_mobile.text,
      //     'employer': ' ',
      //     'profession': ' ',
      //     'emergency_name': _relationNameController.text,
      //     'emergency_relation': selectedRelation != null
      //         ? selectedRelation!
      //         : _relationController.text,
      //     'email_verified': _emailStatus == 'Verify' ? "0" : '1',
      //     'emobile_verified': _eSatatus == 'Verify' ? "0" : '1',
      //     'current_address_house': _currentHouse.text,
      //     'current_address_area': _currentArea.text,
      //     'current_address_landmark': _currentLandmark.text,
      //     'current_address_city': _currentCity.text,
      //     'permanent_address_house': _permanentHouse.text,
      //     'permanent_address_area': _permanentArea.text,
      //     'permanent_address_landmark': _permanentLandmark.text,
      //     'permanent_address_city': _permanentCity.text,
      //   });
      //   request.headers.addAll(headers);
      //   if (_profileImage != null) {
      //     request.files.add(await http.MultipartFile.fromPath(
      //         'image_profile', _profileImage!.path));
      //   }

      //   http.StreamedResponse response = await request.send();
      //   setState(() {
      //     _pb = false;
      //   });
      //   if (response.statusCode == 200) {
      //     var json = jsonDecode(await response.stream.bytesToString());
      //     print(json);
      //     ScaffoldMessenger.of(context)
      //         .showSnackBar(SnackBar(content: Text(json['message'])));
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => const MyHomePage()));
      //   } else {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //         const SnackBar(content: Text('Some error occurred Try again..')));
      //   }
      // }
    }
  }

  Future<void> _sendOTPToEmail(code) async {
    await ref
        .read(moreControllerProvider.notifier)
        .sendOTPEmail(_email.text, code.toString(), context);
  }

  Future<void> _sendOTPToPhone(int code) async {
    await ref
        .read(moreControllerProvider.notifier)
        .sendOTPPhone(_emergency_mobile.text.trim(), code.toString(), context);
  }
}
