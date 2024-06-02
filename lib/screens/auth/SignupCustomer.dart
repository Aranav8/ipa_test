import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridobiko/controllers/auth/auth_controller.dart';
import 'package:ridobiko/screens/rental/MyHomePage.dart';

// ignore: camel_case_types
class Signup_Customer extends ConsumerStatefulWidget {
  const Signup_Customer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return Signup();
  }
}

class Signup extends ConsumerState {
  final _nameText = TextEditingController();
  final _emailText = TextEditingController();
  final _phoneText = TextEditingController();
  final _passText = TextEditingController();
  final _cnfpassText = TextEditingController();

  var _cnfpassError = "";
  var _nameError = "";
  var _emailError = "";
  var _passError = "";
  // @override
  // void initState() {
  //   super.initState();
  //   _getPhone();
  // }

  @override
  Widget build(BuildContext context) {
    _phoneText.text = ref.watch(userProvider)!.mobile!;
    final pb = ref.watch(authControllerProvider);
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
            elevation: 0,
            title: Padding(
                padding: const EdgeInsets.only(right: 30, top: 20),
                child: Center(
                    child: Text('Customer Signup',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 25 / scaleFactor,
                            fontWeight: FontWeight.bold)))),
            backgroundColor: Colors.grey[200],
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyHomePage()),
                  );
                })),
        body: Container(
            margin: const EdgeInsets.only(top: 50),
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  elevation: 7,
                  child: TextField(
                    controller: _nameText,
                    decoration: InputDecoration(
                        errorText: _nameError,
                        hintText: "Enter your full name",
                        hintStyle: TextStyle(
                            fontSize: 14 / scaleFactor, color: Colors.grey),
                        // label:Text("Name"),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
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
                    keyboardType: TextInputType.name,
                    obscureText: false,
                    // maxLength: 15,
                  ),
                ),
                Card(
                  margin: const EdgeInsets.only(top: 20),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  elevation: 7,
                  child: TextField(
                    controller: _emailText,
                    decoration: InputDecoration(
                        errorText: _emailError,
                        hintText: "Enter your Email",
                        hintStyle: TextStyle(
                            fontSize: 14 / scaleFactor, color: Colors.grey),
                        // label:Text("Name"),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
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
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    // maxLength: 15,
                  ),
                ),
                Card(
                  margin: const EdgeInsets.only(top: 20),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  elevation: 7,
                  child: TextField(
                    controller: _phoneText,
                    decoration: InputDecoration(
                        hintText: "Mobile Number",
                        hintStyle: TextStyle(
                            fontSize: 14 / scaleFactor, color: Colors.grey),
                        // label:Text("Name"),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
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
                    keyboardType: TextInputType.phone,
                    obscureText: false,
                    // maxLength: 15,
                  ),
                ),
                Card(
                  margin: const EdgeInsets.only(top: 20),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  elevation: 7,
                  child: TextField(
                    controller: _passText,
                    decoration: InputDecoration(
                        errorText: _passError,
                        hintText: "Password",
                        hintStyle: TextStyle(
                            fontSize: 14 / scaleFactor, color: Colors.grey),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
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
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    // maxLength: 15,
                  ),
                ),
                Card(
                  margin: const EdgeInsets.only(top: 20),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  elevation: 7,
                  child: TextField(
                    controller: _cnfpassText,
                    decoration: InputDecoration(
                        errorText: _cnfpassError,
                        hintText: " Confirm Password",
                        hintStyle: TextStyle(
                            fontSize: 14 / scaleFactor, color: Colors.grey),
                        // label:Text("Name"),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
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
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    // maxLength: 15,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    _signupCustomer();
                  },
                  child: Card(
                    elevation: 7,
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
                                    "Proceed",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20 / scaleFactor),
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
            )));
  }

  void _signupCustomer() async {
    if (_nameText.text.isEmpty) {
      _nameError = "Enter a valid name";
    } else if (_emailText.text.isEmpty) {
      _emailError = "Enter a valid email";
    } else if (_passText.text.isEmpty || _passText.text.length <= 6) {
      _passError = "Enter a password with length greater than 6";
    } else if (_cnfpassText.text != _passText.text) {
      _cnfpassError = "Passwords do not match";
    } else {
      await ref.watch(authControllerProvider.notifier).signupCustomer(
          _nameText.text,
          _phoneText.text,
          _emailText.text,
          _passText.text,
          context);

      // try {
      //   var call = await http.post(
      //       Uri.parse(
      //           'https://www.ridobiko.com/android_app_customer/api/api_signup.php'),
      //       body: {
      //         'mobile': _phoneText.text,
      //         'name': _nameText.text,
      //         'email': _emailText.text,
      //         'pass': _passText.text,
      //       });
      //   var response = jsonDecode(call.body);
      //   if (response['status'] == true) {
      //     _showHomeScreen(response);
      //   } else {
      //     ScaffoldMessenger.of(context)
      //         .showSnackBar(SnackBar(content: Text(response['message'])));
      //   }
      // } catch (e) {
      //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //       content: Text("Some error occurred please try again..")));
      // }
    }
  }

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

  // Future<void> _getPhone() async {
  //   var prefs = await SharedPreferences.getInstance();
  //   _phoneText.text = prefs.getString('mobile') ?? "";
  //   setState(() {});
  // }
}
