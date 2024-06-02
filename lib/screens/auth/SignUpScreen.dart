// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridobiko/controllers/auth/auth_controller.dart';
import 'package:ridobiko/utils/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Login_Screen.dart';

import 'SignupCustomer.dart';

// ignore: must_be_immutable
class SignUpScreen extends ConsumerStatefulWidget {
  bool flag;
  SignUpScreen(this.flag, {super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return signup();
  }
}

// ignore: camel_case_types
class signup extends ConsumerState<SignUpScreen> {
  final _phoneText = TextEditingController();

  final _otpText = TextEditingController();

  var _otpVisible = false;

  int _otp = 1234;

  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;

  CountdownTimerController? _timerController;

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
                      "${!widget.flag ? 'Login' : Signup} to your account now",
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
                      Text("Signup",
                          style: TextStyle(
                              fontSize: 14 / scaleFactor,
                              color: !widget.flag
                                  ? Colors.grey
                                  : const Color.fromRGBO(139, 0, 0, 1))),
                      const SizedBox(width: 30),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          child: Text("Login",
                              style: TextStyle(
                                fontSize: 18 / scaleFactor,
                                color: widget.flag
                                    ? Colors.grey
                                    : const Color.fromRGBO(139, 0, 0, 1),
                              ))),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Card(
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey, width: 0.5),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TextField(
                        controller: _phoneText,
                        maxLength: 10,
                        decoration: InputDecoration(
                            icon: const Icon(Icons.phone_android),
                            hintText: "Phone Number",
                            hintStyle: TextStyle(
                                fontSize: 14 / scaleFactor, color: Colors.grey),
                            counterText: '',
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
                    visible: _otpVisible,
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
                            style: TextStyle(
                              fontSize: 14 / scaleFactor,
                            ),
                            decoration: InputDecoration(
                              icon: const Icon(Icons.email),
                              suffixIconConstraints: const BoxConstraints(),
                              suffixIcon: CountdownTimer(
                                controller: _timerController,
                                widgetBuilder: (context, time) {
                                  if (time == null) {
                                    return GestureDetector(
                                        onTap: () {
                                          _otp = Random().nextInt(6000) + 2000;
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
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      '${time.sec! < 10 ? '0${time.sec}' : time.sec}',
                                      style: TextStyle(
                                        fontSize: 16 / scaleFactor,
                                        color:
                                            const Color.fromRGBO(139, 0, 0, 1),
                                      ),
                                    ),
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
                                borderSide:
                                    BorderSide(color: Colors.white, width: 0.5),
                              ),
                              border: InputBorder.none,
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 0.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              labelStyle: TextStyle(
                                fontSize: 15 / scaleFactor,
                                color: Colors.grey,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            keyboardType: TextInputType.text,
                            obscureText: false,
                            // maxLength: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () async {
                      if (_otpVisible) {
                        if (_otpText.text == _otp.toString()) {
                          await ref
                              .watch(authControllerProvider.notifier)
                              .checkUser(_phoneText.text, context);
                        } else {
                          Toast(context, "Enter a valid OTP");
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
                        Toast(context, "Enter a valid number");
                      }

                      if (_phoneText.text.isEmpty || _otpText.text.isEmpty) {
                        Toast(context, "Please fill all the fields");
                      } else if (_phoneText.text.trim().length != 10) {
                        Toast(context, "Please enter a valid number");
                      } else {
                        final authController =
                            ref.watch(authControllerProvider.notifier);
                        await authController.userLogin(
                          _phoneText.text.trim(),
                          _otpText.text.trim(),
                          context,
                        );

                        final prefs = await SharedPreferences.getInstance();
                        final token = prefs.getString('token');
                        if (token != null) {
                          if (kDebugMode) {
                            print('Token: $token');
                          }
                        }
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
                                      _otpVisible ? "Verify" : "Proceed",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15 / scaleFactor,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
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
  //       // _pb = false;
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

  // Future<void> _checkUser(String phone) async {
  //   try {
  //     var call = await http.post(
  //         Uri.parse(
  //             'https://www.ridobiko.com/android_app_customer/api/api_userstate.php'),
  //         body: {
  //           'mobile': phone,
  //         });
  //     var response = jsonDecode(call.body);
  //     setState(() {
  //       endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  //       _timerController = CountdownTimerController(endTime: endTime);
  //       // _pb = false;
  //     });
  //     if (response['status'] == true) {
  //       var prefs = await SharedPreferences.getInstance();
  //       await prefs.setString('mobile', phone);
  //       if (response['newUser'] == true) {
  //         _showSignupScreen();
  //       } else {
  //         _showHomeScreen(response);
  //       }
  //     } else {
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text(response['message'])));
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text("Some error occurred please try again..")));
  //   }
  // }

  // void _showHomeScreen(res) async {
  //   var response = res['data']['user'];
  //   var prefs = await SharedPreferences.getInstance();
  //   try {
  //     await prefs.setBool('loggedIn', true);
  //     await prefs.setString('token', res['data']['token']);
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
}
