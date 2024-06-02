import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridobiko/controllers/auth/auth_controller.dart';
import 'package:ridobiko/repositories/auth/auth_repository.dart';
import 'package:ridobiko/screens/more/AboutUs.dart';
import 'package:ridobiko/screens/more/CustomerSupport.dart';
import 'package:ridobiko/screens/more/MyAccount.dart';
import 'package:ridobiko/screens/bookings/YourOrder.dart';
import 'package:ridobiko/data/BookingFlow.dart';
import 'package:ridobiko/screens/auth/SignUpScreen.dart';
import 'package:ridobiko/screens/more/NewSecurityDeposit.dart';
import 'package:ridobiko/screens/more/available_coupon_screen.dart';
import 'package:ridobiko/screens/more/referral_team_screen.dart';
import 'DocumentUpload.dart';
import '../auth/Login_Screen.dart';
import 'package:url_launcher/url_launcher.dart';

class More extends ConsumerStatefulWidget {
  const More({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return more();
  }
}

// ignore: camel_case_types
class more extends ConsumerState {
  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            actionsPadding: const EdgeInsets.all(3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            title: const Text(
              "Are you sure you want to logout?",
              style: TextStyle(fontSize: 15, fontFamily: "poppinsM"),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "NO",
                    style: TextStyle(
                      color: Color.fromRGBO(139, 0, 0, 1),
                    ),
                  )),
              TextButton(
                  onPressed: () async {
                    await ref.read(authRepositoryProvider).saveUserData(null);
                    ref.read(userProvider.notifier).update((state) => null);
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (route) => false);
                  },
                  child: const Text(
                    "YES",
                    style: TextStyle(
                      color: Color.fromRGBO(139, 0, 0, 1),
                    ),
                  ))
            ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/logo.png",
                        height: 40,
                      ),
                      Visibility(
                        visible: false,
                        child: Column(
                          children: [
                            Text(
                              'Login/Sign up to get started',
                              style: TextStyle(
                                  fontSize: 20 / scaleFactor,
                                  color: Colors.grey[500]),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.grey[500]!,
                                            width: 1.0)),
                                    padding: const EdgeInsets.all(20),
                                    child: Text(
                                      ' Log In',
                                      style:
                                          TextStyle(fontSize: 15 / scaleFactor),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SignUpScreen(true)),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              const Color.fromRGBO(
                                                  139, 0, 0, 1),
                                              Colors.red[200]!
                                            ]),
                                        border: Border.all(
                                            color: Colors.grey[500]!,
                                            width: 0.5)),
                                    padding: const EdgeInsets.all(20),
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                          fontSize: 15 / scaleFactor,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Image.asset(
                            'assets/icons/user.png',
                            height: 22,
                            color: Colors.black87,
                          ),
                        ),
                        title: Text(
                          'My Account',
                          style: TextStyle(
                            fontSize: 17 / scaleFactor,
                            color: Colors.black87,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: Colors.black87,
                        ),
                        onTap: () {
                          BookingFlow.fromMore = true;

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyAccount()));
                        },
                      ),
                      const Divider(
                        thickness: 0.5,
                      ),
                      ListTile(
                        leading: Image.asset(
                          'assets/icons/profile_verification.png',
                          height: 25,
                          color: Colors.black87,
                        ),
                        title: Text(
                          'Profile Verification',
                          style: TextStyle(
                              fontSize: 17 / scaleFactor,
                              color: Colors.black87),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: Colors.black87,
                        ),
                        onTap: () {
                          BookingFlow.fromMore = true;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const DocUpload()));
                        },
                      ),
                      const Divider(
                        thickness: 0.5,
                      ),
                      ListTile(
                        leading: Image.asset(
                          'assets/icons/security_deposit.png',
                          height: 25,
                          color: Colors.black87,
                        ),
                        title: Text(
                          'Security Deposit',
                          style: TextStyle(
                              fontSize: 17 / scaleFactor,
                              color: Colors.black87),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: Colors.black87,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewSecurityDepoPB()));
                        },
                      ),
                      const Divider(
                        thickness: 0.5,
                      ),
                      ListTile(
                        leading: Image.asset(
                          'assets/icons/shopping-bag.png',
                          height: 28,
                          color: Colors.black87,
                        ),
                        title: Text(
                          'My Orders',
                          style: TextStyle(
                            fontSize: 17 / scaleFactor,
                            color: Colors.black87,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: Colors.black87,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const YourOrder()));
                        },
                      ),
                      const Divider(
                        thickness: 0.5,
                      ),
                      ListTile(
                        leading: Image.asset(
                          'assets/images/team.png',
                          height: 24,
                          color: Colors.black87,
                        ),
                        title: Text(
                          'Referral Team',
                          style: TextStyle(
                            fontSize: 17 / scaleFactor,
                            color: Colors.black87,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: Colors.black87,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ReferralTeamScreen()));
                        },
                      ),
                      const Divider(
                        thickness: 0.5,
                      ),
                      ListTile(
                        leading: Image.asset(
                          'assets/images/coupon.png',
                          height: 28,
                          color: Colors.black87,
                        ),
                        title: Text(
                          'Available Coupons',
                          style: TextStyle(
                            fontSize: 17 / scaleFactor,
                            color: Colors.black87,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: Colors.black87,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AvailableCouponsScreen()));
                        },
                      ),
                      const Divider(
                        thickness: 0.5,
                      ),
                      ListTile(
                        leading: Image.asset(
                          'assets/icons/online-support.png',
                          height: 25,
                          color: Colors.black87,
                        ),
                        title: Text(
                          'Customer Support',
                          style: TextStyle(
                            fontSize: 17 / scaleFactor,
                            color: Colors.black87,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: Colors.black87,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Customer()));
                        },
                      ),
                      const Divider(
                        thickness: 0.5,
                      ),
                      ListTile(
                        leading: Image.asset(
                          'assets/icons/about.png',
                          height: 25,
                          color: Colors.black87,
                        ),
                        title: Text(
                          'About us',
                          style: TextStyle(
                              fontSize: 17 / scaleFactor,
                              color: Colors.black87),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: Colors.black87,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AboutUs()));
                        },
                      ),
                      const Divider(thickness: 0.5),
                      ListTile(
                        leading: Image.asset(
                          'assets/icons/terms-and-conditions.png',
                          height: 25,
                          color: Colors.black87,
                        ),
                        title: Text(
                          'Terms and Conditions',
                          style: TextStyle(
                              fontSize: 17 / scaleFactor,
                              color: Colors.black87),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: Colors.black87,
                        ),
                        onTap: () {
                          // ignore: deprecated_member_use
                          launch('https://www.ridobiko.com/Terms.php');
                        },
                      ),
                      const Divider(
                        thickness: 0.5,
                      ),
                      ListTile(
                          leading: Image.asset(
                            'assets/icons/review.png',
                            height: 25,
                            color: Colors.black87,
                          ),
                          title: Text(
                            'Rate us',
                            style: TextStyle(
                                fontSize: 17 / scaleFactor,
                                color: Colors.black87),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Colors.black87,
                          ),
                          onTap: () async {
                            const playStoreUrl =
                                'https://play.google.com/store/apps/details?id=com.ridobikocustomer.app';
                            const appStoreUrl =
                                'https://www.apple.com/in/app-store/';
                            await launchUrl(
                              Uri.parse(Platform.isAndroid
                                  ? playStoreUrl
                                  : appStoreUrl),
                              mode: LaunchMode.externalApplication,
                            );
                          }),
                      const Divider(
                        thickness: 0.5,
                      ),
                      GestureDetector(
                        onTap: () async {
                          _showLogoutConfirmationDialog();
                        },
                        child: ListTile(
                          leading: Image.asset(
                            'assets/icons/logout.png',
                            height: 25,
                            color: Colors.black87,
                          ),
                          title: Text(
                            'Logout',
                            style: TextStyle(
                                fontSize: 17 / scaleFactor,
                                color: Colors.black87),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
