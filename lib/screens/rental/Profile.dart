import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ridobiko/screens/more/DocumentUpload.dart';
import 'package:ridobiko/controllers/auth/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Profile extends ConsumerStatefulWidget {
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
  String _tempEmail = "";
  String _tempEmergencyMobile = "";
  String _tempcurrHouse = "";
  String _tempcurrArea = "";
  String _tempcurrLand = "";
  String _tempcuuCity = "";
  String _tempperHouse = "";
  String _tempperArea = "";
  String _tempperLand = "";
  String _tempperCity = "";

  String _relationName = "";

  final _name = TextEditingController();

  final _email = TextEditingController();

  final _mobile = TextEditingController();
  final _relationController = TextEditingController();
  final _relationNameController = TextEditingController();

  final _emergency_mobile = TextEditingController();

  String _emailStatus = 'Verify';
  bool isDisabled = false;
  String? selectedRelation;

  final List<String> relation = [
    "Friend",
    "Sibling",
    "Spouse",
    "Parents",
    "Relative",
    "Other"
  ];
  String mobo = '';
  String _eSatatus = 'Verify';

  final _currentHouse = TextEditingController();

  final _currentArea = TextEditingController();

  final _currentLandmark = TextEditingController();

  final _currentCity = TextEditingController();

  final _permanentHouse = TextEditingController();

  final _permanentArea = TextEditingController();

  final _permanentLandmark = TextEditingController();

  final _permanentCity = TextEditingController();

  XFile? _profileImage;
  var _pb = true;
  var _profile = '';

  @override
  void initState() {
    _getUserDetails();
    setState(() {
      _pb = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      floatingActionButton: _pb ? const CircularProgressIndicator() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
          elevation: 0,
          // title: Align(alignment: Alignment.centerRight,child: Text('STEP 1/3',style: TextStyle(color: Colors.white,fontSize: 15))),

          backgroundColor: const Color.fromRGBO(139, 0, 0, 1),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              })),
      body: Container(
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
                      side: const BorderSide(color: Colors.grey, width: 0.5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 10,
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 10, left: 30, bottom: 10, right: 20),
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
                                        decoration: TextDecoration.underline,
                                        color: Colors.grey[400],
                                        fontSize: 15),
                                  ))
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: TextField(
                              controller: _name,
                              decoration: InputDecoration(
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 0.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey[200]!, width: 0.5),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  labelStyle: const TextStyle(
                                    fontSize: 17,
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
                      side: const BorderSide(color: Colors.grey, width: 0.5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 10,
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 10, left: 30, bottom: 10, right: 20),
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
                                        decoration: TextDecoration.underline,
                                        color: Colors.grey[400],
                                        fontSize: 15),
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
                                        hintStyle:
                                            const TextStyle(color: Colors.grey),
                                        enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 0.5),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        border: InputBorder.none,
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey[200]!,
                                                width: 0.5),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        labelStyle: const TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                        ),
                                        fillColor: Colors.white,
                                        filled: true),
                                    keyboardType: TextInputType.emailAddress,
                                    obscureText: false,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    if (_emailStatus == 'Verified') return;
                                    var rng = Random();
                                    var code = rng.nextInt(9000) + 1000;
                                    _sendOTPToEmail(code);
                                    showDialog(
                                        context: context,
                                        builder: (bContext) {
                                          var inputCode =
                                              TextEditingController();
                                          var errorText = '';
                                          return StatefulBuilder(
                                            builder: (BuildContext context,
                                                void Function(void Function())
                                                    setState) {
                                              return AlertDialog(
                                                title: const Align(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    child: Text(
                                                        'The OTP Sent on Email')),
                                                content: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  10))),
                                                  child: TextField(
                                                    textAlign: TextAlign.left,
                                                    controller: inputCode,
                                                    decoration: InputDecoration(
                                                      enabledBorder: const OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .black,
                                                                  width: 0.5),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                      border: InputBorder.none,
                                                      focusedBorder: const OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .black,
                                                                  width: 0.5),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                      hintText: "Enter OTP",
                                                      errorText: errorText,
                                                    ),
                                                    onChanged: (value) {
                                                      errorText = '';
                                                      setState(() {});
                                                    },
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  ElevatedButton(
                                                    child: const Text('Verify'),
                                                    onPressed: () {
                                                      setState(() {
                                                        if (inputCode.text ==
                                                            code.toString()) {
                                                          _emailStatus =
                                                              'Verified';
                                                          _tempEmail =
                                                              _email.text;
                                                          setState(() {});
                                                          _updateEmailVerification();
                                                          Navigator.pop(
                                                              bContext);
                                                          setState(() {});
                                                        } else {
                                                          errorText =
                                                              'Invalid otp';
                                                          setState(() {});
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        });
                                  },
                                  child: Text(
                                    _emailStatus,
                                    style: TextStyle(
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
                      side: const BorderSide(color: Colors.grey, width: 0.5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 10,
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 10, left: 30, bottom: 10, right: 20),
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
                                        decoration: TextDecoration.underline,
                                        color: Colors.grey[400],
                                        fontSize: 15),
                                  ))
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: TextField(
                              controller: _mobile,
                              enabled: false,
                              decoration: InputDecoration(
                                  suffix: const Text(
                                    "Verified",
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 15),
                                  ),
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 0.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey[200]!, width: 0.5),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  labelStyle: const TextStyle(
                                    fontSize: 17,
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
                      side: const BorderSide(color: Colors.grey, width: 0.5),
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
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[200]!,
                                              width: 0.5),
                                          borderRadius: const BorderRadius.all(
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
                                  onTap: () {
                                    if (_eSatatus == 'Verified') return;
                                    if (_emergency_mobile.text.length != 10) {
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
                                    var code = rng.nextInt(9000) + 1000;
                                    //print(code);
                                    _sendOTPToPhone(code);
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (bContext) {
                                          var inputCode =
                                              TextEditingController();
                                          var errorText = '';
                                          return StatefulBuilder(
                                            builder: (BuildContext context,
                                                void Function(void Function())
                                                    setState) {
                                              return AlertDialog(
                                                title: Text(
                                                    'The OTP Sent on Mobile',
                                                    style: TextStyle(
                                                        fontSize:
                                                            14 / scaleFactor)),
                                                content: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  10))),
                                                  child: TextField(
                                                    controller: inputCode,
                                                    decoration: InputDecoration(
                                                        enabledBorder: const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width: 0.5),
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        10))),
                                                        border:
                                                            InputBorder.none,
                                                        focusedBorder: const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width: 0.5),
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        10))),
                                                        hintText: "Enter OTP",
                                                        errorText: errorText),
                                                    onChanged: (value) {
                                                      errorText = '';
                                                      setState(() {});
                                                    },
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  ElevatedButton(
                                                    child: Text('Verify',
                                                        style: TextStyle(
                                                            fontSize: 14 /
                                                                scaleFactor)),
                                                    onPressed: () {
                                                      setState(() {
                                                        if (inputCode.text ==
                                                            code.toString()) {
                                                          _eSatatus =
                                                              'Verified';
                                                          _tempEmergencyMobile =
                                                              _emergency_mobile
                                                                  .text;
                                                          setState(() {});
                                                          _updateENumberVerification();
                                                          Navigator.pop(
                                                              bContext);
                                                          setState(() {});
                                                        } else {
                                                          errorText =
                                                              'Invalid otp';
                                                          setState(() {});
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
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
                                          controller: _relationNameController,
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
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(10))),
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
                                              labelText: " Name",
                                              hintText:
                                                  "Enter name of number owner"),
                                        ))),
                              ),
                            ],
                          ),
                          isDisabled
                              ? Row(
                                  children: [
                                    Flexible(
                                      child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Directionality(
                                              textDirection: TextDirection.ltr,
                                              child: TextField(
                                                enabled: false,
                                                textAlign: TextAlign.left,
                                                controller: _relationController,
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
                                                    labelText: " Relation",
                                                    hintText: "Enter name of number owner"),
                                              ))),
                                    ),
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
                                    items:
                                        relation.map<DropdownMenuItem<String>>(
                                      (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value,
                                              style: TextStyle(
                                                  fontSize: 14 / scaleFactor)),
                                        );
                                      },
                                    ).toList(),
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
                        side: const BorderSide(color: Colors.grey, width: 0.5),
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
                                    padding: const EdgeInsets.only(left: 10),
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
                                                  borderSide:
                                                      BorderSide(
                                                          color: Colors.grey,
                                                          width: 0.5),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                          border: InputBorder.none,
                                          focusedBorder:
                                              const OutlineInputBorder(
                                                  borderSide:
                                                      BorderSide(
                                                          color: Colors.grey,
                                                          width: 0.5),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
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
                        child: const Padding(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Save & Continue",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15),
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
                padding: const EdgeInsets.only(top: 50, right: 20, left: 20),
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
                    child: Stack(alignment: Alignment.bottomCenter, children: [
                      Center(
                        child: Text(
                          _customerName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        'Account Details',
                        style: TextStyle(
                            fontSize: 25,
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
                            title: const Text(
                                "From where do you want to take the photo?"),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
/*                                 GestureDetector(
                                   child: const Text("Gallery"),
                                   onTap: () async {
                                     _profileImage= await ImagePicker().pickImage(source: ImageSource.gallery);
                                     Navigator.pop(bcontext);
                                     setState((){});
                                   },
                                 ),*/
                                  const Padding(padding: EdgeInsets.all(8.0)),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      child: const Text("Camera"),
                                      onTap: () async {
                                        _profileImage = await ImagePicker()
                                            .pickImage(
                                                source: ImageSource.camera);
                                        // ignore: use_build_context_synchronously
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
                      : Image.network(_profile,
                          errorBuilder: (context, o, trace) {
                          return const Text('No Image');
                        }).image,

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
    );
  }

  _updateENumberVerification() async {
    setState(() {
      _pb = true;
    });
    String token = ref.read(userProvider)!.token!;

    var headers = {'token': token};
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://www.ridobiko.com/android_app_customer/api/setUserDetails.php'));
    request.fields.addAll({
      'name': _tempName,
      'email': _tempEmail,
      'emergency_no': _emergency_mobile.text,
      'employer': ' ',
      'profession': ' ',
      'email_verified': _emailStatus == 'Verify' ? "0" : '1',
      'emobile_verified': '1',
      'current_address_house': _tempcurrHouse,
      'current_address_area': _tempcurrArea,
      'current_address_landmark': _tempcurrLand,
      'current_address_city': _tempcuuCity,
      'permanent_address_house': _tempperHouse,
      'permanent_address_area': _tempperArea,
      'permanent_address_landmark': _tempperLand,
      'permanent_address_city': _tempperCity,
    });
    request.headers.addAll(headers);
    if (_profileImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'image_profile', _profileImage!.path));
    }

    http.StreamedResponse response = await request.send();
    setState(() {
      _pb = false;
    });
    var json = jsonDecode(await response.stream.bytesToString());
    print(json);
  }

  void _getUserDetails() async {
    String token = ref.read(userProvider)!.token!;

    debugPrint(token);

    var call = await http.post(
        Uri.parse(
            'https://www.ridobiko.com/android_app_customer/api/getUserDetials.php'),
        headers: {
          'token': token,
        });
    var response = jsonDecode(call.body);
    setState(() {
      _pb = false;
    });
    if (response['success']) {
      var data = response['data'];
      _name.text = data['name'];
      _tempName = data['name'];
      _customerName = data['name'];
      _profile = data['profile_image'];
      _email.text = data['email'];
      _tempEmail = data['email'];
      _emergency_mobile.text = data['emergency_mobile'];
      _tempEmergencyMobile = data['emergency_mobile'];
      _mobile.text = data['mobile'];
      mobo = data['mobile'];
      _currentHouse.text = data['current_address_house'] ?? "";
      _tempcurrHouse = data['current_address_house'] ?? "";
      _currentArea.text = data['current_address_area'] ?? "";
      _tempcurrArea = data['current_address_area'] ?? "";
      _currentLandmark.text = data['current_address_landmark'] ?? "";
      _tempcurrLand = data['current_address_landmark'] ?? "";
      _currentCity.text = data['current_address_city'] ?? "";
      _tempcuuCity = data['current_address_city'] ?? "";
      _permanentHouse.text = data['permanent_address_house'] ?? "";
      _tempperHouse = data['permanent_address_house'] ?? "";
      _permanentArea.text = data['permanent_address_area'] ?? "";
      _tempperArea = data['permanent_address_area'] ?? "";
      _permanentLandmark.text = data['permanent_address_landmark'] ?? "";
      _tempperLand = data['permanent_address_landmark'] ?? "";
      _permanentCity.text = data['permanent_address_city'] ?? "";
      _tempperCity = data['permanent_address_city'] ?? "";
      _relationName = data['emergency_name'] ?? "";
      _relationNameController.text = data['emergency_name'] ?? "";
      _relationController.text = data['emergency_relation'] ?? "";
      //  selectedRelation = data['emergency_relation']??"";
      _emailStatus = data['email_verified'] == '1' ? "Verified" : 'Verify';
      _eSatatus =
          data['emergency_mobile_verified'] == '1' ? "Verified" : 'Verify';
    }
    if (kDebugMode) {
      print(selectedRelation);
    }

    if (_relationController.text != "") {
      selectedRelation = _relationController.text;

      isDisabled = true;
    }

    setState(() {});
    _checkForTrips(token);
    setState(() {});
  }

  _checkForTrips(String token) async {
    const url =
        'https://www.ridobiko.com/android_app_customer/api/detailsEditableCheck.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'token': token,
        },
      );
      print(response.body);
      final responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody["success"] == true) {
        if (responseBody["data"]["proceed"] == 1) {
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
      }
    } catch (e) {}
  }

  _updateEmailVerification() async {
    setState(() {
      _pb = true;
    });
    String token = ref.read(userProvider)!.token!;

    var headers = {'token': token};
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://www.ridobiko.com/android_app_customer/api/setUserDetails.php'));
    request.fields.addAll({
      'name': _tempName,
      'email': _email.text,
      'emergency_no': _tempEmergencyMobile,
      'employer': ' ',
      'profession': ' ',
      'email_verified': '1',
      'emobile_verified': _eSatatus == 'Verify' ? "0" : '1',
      'current_address_house': _tempcurrHouse,
      'current_address_area': _tempcurrArea,
      'current_address_landmark': _tempcurrLand,
      'current_address_city': _tempcuuCity,
      'permanent_address_house': _tempperHouse,
      'permanent_address_area': _tempperArea,
      'permanent_address_landmark': _tempperLand,
      'permanent_address_city': _tempperCity,
    });
    request.headers.addAll(headers);
    if (_profileImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'image_profile', _profileImage!.path));
    }

    http.StreamedResponse response = await request.send();
    setState(() {
      _pb = false;
    });
    var json = jsonDecode(await response.stream.bytesToString());
    print(json);
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
      String token = ref.read(userProvider)!.token!;

      var headers = {'token': token};
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://www.ridobiko.com/android_app_customer/api/setUserDetails.php'));
      request.fields.addAll({
        'name': _name.text,
        'email': _email.text,
        'emergency_no': _emergency_mobile.text,
        'employer': ' ',
        'profession': ' ',
        'emergency_name': _relationNameController.text,
        'emergency_relation': selectedRelation != null
            ? selectedRelation!
            : _relationController.text,
        'email_verified': _emailStatus == 'Verify' ? "0" : '1',
        'emobile_verified': _eSatatus == 'Verify' ? "0" : '1',
        'current_address_house': _currentHouse.text,
        'current_address_area': _currentArea.text,
        'current_address_landmark': _currentLandmark.text,
        'current_address_city': _currentCity.text,
        'permanent_address_house': _permanentHouse.text,
        'permanent_address_area': _permanentArea.text,
        'permanent_address_landmark': _permanentLandmark.text,
        'permanent_address_city': _permanentCity.text,
      });
      request.headers.addAll(headers);
      if (_profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'image_profile', _profileImage!.path));
      }

      http.StreamedResponse response = await request.send();
      setState(() {
        _pb = false;
      });
      if (response.statusCode == 200) {
        var json = jsonDecode(await response.stream.bytesToString());
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(json['message'])));
        // ignore: use_build_context_synchronously
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const DocUpload()));
        // Navigator.push(context, MaterialPageRoute(builder: (context) => LicenseUpload()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Some error occurred Try again..')));
      }
    }
  }

  Future<void> _sendOTPToEmail(code) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? "";
    var call = await http.post(
        Uri.parse(
            'https://www.ridobiko.com/android_app_customer/api/sendEmailOTP.php'),
        headers: {
          'token': token,
        },
        body: {
          'email_otp': code.toString(),
          'email': _email.text,
        });

    if (kDebugMode) {
      print(call.body);
    }
  }

  Future<void> _sendOTPToPhone(int code) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? "";
    var call = await http.post(
        Uri.parse(
            'https://www.ridobiko.com/android_app_customer/api/sendEmergencyOTP.php'),
        headers: {
          'token': token,
        },
        body: {
          'emergency_otp': code.toString(),
          'emergency_mobile': _emergency_mobile.text,
        });

    if (kDebugMode) {
      print(call.body);
    }
  }
}
