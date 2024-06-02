// ignore: file_names
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridobiko/utils/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ridobiko/controllers/auth/auth_controller.dart';
import 'package:ridobiko/screens/auth/SignUpScreen.dart';
import 'package:ridobiko/screens/auth/forget_pass.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return Otp();
  }
}

class Otp extends ConsumerState {
  final _phoneController = TextEditingController();

  final _passController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkForUpdate();
  }

  @override
  Widget build(BuildContext context) {
    var pb = ref.watch(authControllerProvider);
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color(0xFF8B0000),
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white),
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                })),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                // alignment:Alignment.topLeft,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                height: 300,
                color: const Color.fromRGBO(139, 0, 0, 1),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome back!",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20 / scaleFactor,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Login to your account now",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15 / scaleFactor,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 280,
                child: Container(
                  height: 2000,
                  // alignment:Alignment.topLeft,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(10),
                  color: Colors.grey[300],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                margin: const EdgeInsets.only(top: 80, right: 20, left: 20),
                padding: const EdgeInsets.all(20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text("Login",
                              style: TextStyle(
                                  color: const Color.fromRGBO(139, 0, 0, 1),
                                  fontSize: 18 / scaleFactor)),
                          const SizedBox(
                            width: 30,
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SignUpScreen(true)));
                              },
                              child: Text("Signup",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18 / scaleFactor))),
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
                            controller: _phoneController,
                            maxLength: 10,
                            decoration: InputDecoration(
                              icon: const Icon(Icons.phone_android),
                              hintText: "Phone Number",
                              hintStyle: TextStyle(
                                  fontSize: 14 / scaleFactor,
                                  color: Colors.grey),
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
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              labelStyle: TextStyle(
                                fontSize: 15 / scaleFactor,
                                color: Colors.grey,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            keyboardType: TextInputType.number,
                            obscureText: false,
                            maxLines: 1,
                            // maxLength: 15,
                          ),
                        ),
                      ),
                      Card(
                        margin: const EdgeInsets.only(top: 20),
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, left: 12),
                          child: TextField(
                            controller: _passController,
                            decoration: InputDecoration(
                                icon: const Icon(Icons.security),
                                hintText: "Password",
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
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            // maxLength: 15,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => ForgetPassword()));
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Forget Password',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 17 / scaleFactor,
                              color: const Color.fromRGBO(139, 0, 0, 1),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () async {
                          if (_phoneController.text.isEmpty ||
                              _passController.text.isEmpty) {
                            Toast(context, "Please fill all the fields");
                          } else if (_phoneController.text.trim().length !=
                              10) {
                            Toast(context, "Please enter a valid number");
                          } else {
                            final authController =
                                ref.watch(authControllerProvider.notifier);
                            await authController.userLogin(
                              _phoneController.text.trim(),
                              _passController.text.trim(),
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
                              padding: const EdgeInsets.all(15),
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
                                          "Login",
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
                      const SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              height: 0.5,
                              color: Colors.grey,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Text("Or",
                                style: TextStyle(
                                    fontSize: 14 / scaleFactor,
                                    color: Colors.grey)),
                          ),
                          Expanded(
                            child: Container(
                              height: 0.5,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => SignUpScreen(false)));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          // margin: EdgeInsets.only(top: 10,bottom: 20,right: 90,left: 90),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              border: Border.all(
                                  color: const Color.fromRGBO(139, 0, 0, 1))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Login with OTP",
                                style: TextStyle(
                                    color: const Color.fromRGBO(139, 0, 0, 1),
                                    fontSize: 15 / scaleFactor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ));
  }

  // Future<void> _loginUser(String mobile, String password) async {
  //   try {
  //     var call = await http.post(
  //         Uri.parse(
  //             'https://www.ridobiko.com/android_app_customer/api/api_login.php'),
  //         body: {'mobile': mobile, 'pass': password});
  //     setState(() {});
  //     var response = jsonDecode(call.body);
  //     print(response); // Print the entire response data
  //     if (response['status'] == true) {
  //       _showHomeScreen(response['data']);
  //     } else {
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text(response['message'])));
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text("Some error occurred please try again..")));
  //   }
  // }

  Future<void> checkForUpdate() async {
    final response =
        await ref.read(authControllerProvider.notifier).checkForUpdate(context);
    if (response) {
      showUpdateAlertBox();
    }
  }

  void showUpdateAlertBox() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Update Available'),
            content: const Text(
                'New version of app is available. Please update the app to continue.'),
            actions: [
              TextButton(
                child: const Text(
                  'Update',
                  style: TextStyle(
                    color: Color.fromRGBO(139, 0, 0, 1),
                  ),
                ),
                onPressed: () {
                  if (Platform.isIOS) {
                    // ignore: deprecated_member_use
                    launch(
                        'https://apps.apple.com/in/app/ridobiko-scooter-bike-rental/id1667260245');
                  } else if (Platform.isAndroid) {
                    // ignore: deprecated_member_use
                    launch(
                        'https://play.google.com/store/apps/details?id=com.ridobikocustomer.app');
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

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
  //     printStoredToken(); // Call to print the stored token
  //     Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(builder: (builder) => const MyHomePage()),
  //         (route) => false);
  //   } catch (e) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text(Constants.wentWrong)));
  //   }
  // }
  // void printStoredToken() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('token');
  //   if (token != null) {
  //     print('Stored token: $token');
  //   } else {
  //     print('Token not found in SharedPreferences');
  //   }
  // }
}
