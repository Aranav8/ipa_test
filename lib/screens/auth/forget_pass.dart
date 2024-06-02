// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridobiko/controllers/auth/auth_controller.dart';
import 'package:ridobiko/utils/snackbar.dart';

import '../../core/Constants.dart';

// ignore: must_be_immutable
class ForgetPassword extends ConsumerStatefulWidget {
  var flag = true;

  ForgetPassword({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return signup();
  }
}

// ignore: camel_case_types
class signup extends ConsumerState<ForgetPassword> {
  final _phoneText = TextEditingController();

  final _otpText = TextEditingController();

  var _otpVisible = false;

  int _otp = 1234;

  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;

  CountdownTimerController? _timerController;

  String _number = '';

  var _passFeils = false;

  final _cnfmpassText = TextEditingController();
  final _passText = TextEditingController();

  void onEnd() {
    //print('onEnd');
  }
  @override
  void initState() {
    _timerController = CountdownTimerController(endTime: endTime);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;
    var pb = ref.watch(authControllerProvider);

    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color.fromRGBO(139, 0, 0, 1),
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white),
                onPressed: () {
                  // Navigator.pop(context);
                  Navigator.pop(context);
                })),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                // alignment:Alignment.topLeft,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(top: 40),
                height: 300,
                color: const Color.fromRGBO(139, 0, 0, 1),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome !",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25 / scaleFactor,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Reset your password",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20 / scaleFactor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                margin: const EdgeInsets.only(top: 150, right: 20, left: 20),
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  Row(
                    children: [
                      Text("Forgot Password",
                          style: TextStyle(
                              fontSize: 18 / scaleFactor,
                              color: const Color.fromRGBO(139, 0, 0, 1))),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Card(
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey, width: 0.5),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TextField(
                        controller: _phoneText,
                        decoration: InputDecoration(
                            icon: const Icon(Icons.phone_android),
                            hintText: "Phone Number",
                            hintStyle: TextStyle(
                                fontSize: 14 / scaleFactor, color: Colors.grey),
                            // label:Text("Name"),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.5),
                            ),
                            border: InputBorder.none,
                            focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 0.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            labelStyle: TextStyle(
                              fontSize: 15 / scaleFactor,
                              color: Colors.grey,
                            ),
                            fillColor: Colors.white,
                            filled: true),
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        // maxLength: 15,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _otpVisible & !_passFeils,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Card(
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: TextField(
                            controller: _otpText,
                            decoration: InputDecoration(
                                icon: const Icon(Icons.email),
                                suffixIconConstraints: const BoxConstraints(),
                                suffixIcon: CountdownTimer(
                                  controller: _timerController,
                                  widgetBuilder: (context, time) {
                                    if (time == null) {
                                      return GestureDetector(
                                          onTap: () {
                                            _otp =
                                                Random().nextInt(6000) + 2000;
                                            endTime = DateTime.now()
                                                    .millisecondsSinceEpoch +
                                                1000 * 30;
                                            _timerController =
                                                CountdownTimerController(
                                                    endTime: endTime);
                                            setState(() {});
                                            ref
                                                .watch(authControllerProvider
                                                    .notifier)
                                                .sentOtp(_phoneText.text, _otp,
                                                    context);
                                          },
                                          child: Text(
                                            'Resend OTP',
                                            style: TextStyle(
                                                fontSize: 14 / scaleFactor,
                                                color: Colors.blue),
                                          ));
                                    }
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Text(
                                          '${time.sec! < 10 ? '0${time.sec}' : time.sec}',
                                          style: TextStyle(
                                              fontSize: 16 / scaleFactor,
                                              color: const Color.fromRGBO(
                                                  139, 0, 0, 1))),
                                    );
                                  },
                                  endWidget: Container(),
                                  endTime: endTime,
                                  textStyle: TextStyle(
                                      fontSize: 14 / scaleFactor,
                                      color: Colors.black),
                                ),
                                hintText: "OTP",
                                hintStyle: TextStyle(
                                    fontSize: 14 / scaleFactor,
                                    color: Colors.grey),
                                // label:Text("Name"),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 0.5),
                                ),
                                border: InputBorder.none,
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 0.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                labelStyle: TextStyle(
                                  fontSize: 15 / scaleFactor,
                                  color: Colors.grey,
                                ),
                                fillColor: Colors.white,
                                filled: true),
                            keyboardType: TextInputType.text,
                            obscureText: false,
                            // maxLength: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _passFeils,
                    child: Card(
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: TextField(
                          controller: _passText,
                          decoration: InputDecoration(
                              icon: const Icon(Icons.password),
                              hintText: "New Password",
                              hintStyle: TextStyle(
                                  fontSize: 14 / scaleFactor,
                                  color: Colors.grey),
                              // label:Text("Name"),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                    BorderSide(color: Colors.white, width: 0.5),
                              ),
                              border: InputBorder.none,
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 0.5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              labelStyle: TextStyle(
                                fontSize: 15 / scaleFactor,
                                color: Colors.grey,
                              ),
                              fillColor: Colors.white,
                              filled: true),
                          // keyboardType: TextInputType.text,
                          obscureText: true,
                          // maxLength: 15,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _passFeils,
                    child: Card(
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: TextField(
                          controller: _cnfmpassText,
                          decoration: InputDecoration(
                              icon: const Icon(Icons.password),
                              hintText: "Confirm New Password",
                              hintStyle: TextStyle(
                                  fontSize: 14 / scaleFactor,
                                  color: Colors.grey),
                              // label:Text("Name"),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                    BorderSide(color: Colors.white, width: 0.5),
                              ),
                              border: InputBorder.none,
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 0.5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              labelStyle: TextStyle(
                                fontSize: 15 / scaleFactor,
                                color: Colors.grey,
                              ),
                              fillColor: Colors.white,
                              filled: true),
                          // keyboardType: TextInputType.number,
                          obscureText: true,
                          // maxLength: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      if (_passFeils) {
                        if (_passText.text.trim() != "" &&
                            _cnfmpassText.text.trim() != "" &&
                            _passText.text == _cnfmpassText.text) {
                          await ref
                              .watch(authControllerProvider.notifier)
                              .resetPassword(
                                  _number, _cnfmpassText.text, context);
                        } else if (_passText.text.trim() == "" ||
                            _cnfmpassText.text.trim() == "") {
                          Toast(context, "Please fill all the fields");
                        } else {
                          Toast(context, "Password dose not match");
                        }
                      }
                      if (_otpVisible) {
                        if (_otpText.text == _otp.toString()) {
                          _number = _phoneText.text;
                          _passFeils = true;
                          setState(() {});
                        } else {
                          Toast(context, "Invalid Phone Number");
                        }
                        return;
                      }
                      if (_phoneText.text.length == 10) {
                        _otp = Random().nextInt(6000) + 2000;
                        _otpVisible = await ref
                            .watch(authControllerProvider.notifier)
                            .sentOtp(_phoneText.text, _otp, context);
                        setState(() {});
                      } else {
                        Toast(context, Constants.checkPhone);
                      }
                    },
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
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
                              pb
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      _passFeils
                                          ? 'Save'
                                          : _otpVisible
                                              ? "Verify"
                                              : "Proceed",
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
                  const SizedBox(
                    height: 30,
                  ),
                ]),
              ),
            ],
          ),
        ));
  }

  // Future<void> _sentOtp(String phone, int otp) async {
  //   try {
  //     var call = await http.post(
  //         Uri.parse(
  //             'https://www.ridobiko.com/android_app_customer/api/api_otp.php'),
  //         body: {'mobile': phone, 'otp': otp.toString()});
  //     setState(() {
  //       //     _pb = false;
  //     });
  //     var response = jsonDecode(call.body);
  //     if (response['status'] == true) {
  //       var prefs = await SharedPreferences.getInstance();
  //       await prefs.setString('mobile', phone);
  //       _otpVisible = true;
  //       setState(() {});
  //     } else {
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text(response['message'])));
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text("Some error occurred please try again..")));
  //   }
  // }

  // Future<void> _resetPassword() async {
  //   setState(() {
  //     //  _pb = true;
  //   });
  //   try {
  //     var call = await http.post(
  //         Uri.parse(
  //             'https://www.ridobiko.com/android_app_customer/api/forgotPassword.php'),
  //         body: {
  //           'mobile': _number,
  //           'new_password': _cnfmpassText.text,
  //         });
  //     setState(() {
  //       //  _pb = false;
  //     });
  //     var response = jsonDecode(call.body);
  //     //print(response);
  //     if (response['status'] == true) {
  //       _showHomeScreen(response['data']);
  //     } else {
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text(response['message'])));
  //     }
  //   } catch (e) {
  //     //print(e);
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text("Some error occurred please try again..")));
  //   }
  // }

  // void _showHomeScreen(res) async {
  //   var response = res['user'];
  //   var prefs = await SharedPreferences.getInstance();
  //   try {
  //     await prefs.setBool('loggedIn', true);
  //     await prefs.setString('token', res['token']);
  //     await prefs.setString('firstname', response['firstname']);
  //     await prefs.setString('lastname', response['lastname']);
  //     await prefs.setString('email', response['email']);
  //     await prefs.setString('mobile', response['mobile']);
  //     Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(builder: (builder) => const MyHomePage()),
  //         (route) => false);
  //   } catch (e) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text(Constants.wentWrong)));
  //   }
  // }

  // void _showSignupScreen() {
  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (builder) => Signup_Customer()));
  // }

  // void _sendDataToServer() {}
}
