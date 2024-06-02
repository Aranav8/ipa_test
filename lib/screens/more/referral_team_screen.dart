// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridobiko/controllers/more/more_controller.dart';

class ReferralTeamScreen extends ConsumerStatefulWidget {
  const ReferralTeamScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ReferralTeamScreenState();
}

class _ReferralTeamScreenState extends ConsumerState<ReferralTeamScreen> {
  List<String> name = [];
  List<String> mobileNumber = [];
  bool isLoading = true;
  final memberNameController = TextEditingController();
  final memberMobileController = TextEditingController();

  Future<void> _showConfirmDialog(
      bool isSuccess, String message, BuildContext mainContext) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 175,
              child: Column(
                children: [
                  SizedBox(
                    height: 80,
                    child: Image.asset(isSuccess
                        ? "assets/images/success.png"
                        : "assets/images/error.png"),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    message,
                    style: const TextStyle(
                        fontFamily: "poppinsM",
                        fontSize: 12,
                        color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: const Color.fromRGBO(139, 0, 0, 1),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: const Text(
                      "OKAY",
                      style: TextStyle(
                          fontFamily: "poppinsM",
                          fontSize: 14,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showAddReferralDialog(BuildContext mainContext) async {
    return showDialog(
      context: context,
      builder: (BuildContext ncontext) {
        bool otpLoading = false;

        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: const Text(
              'Add Details',
              style: TextStyle(fontFamily: "poppinsM"),
            ),
            content: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Text(
                    "Add the details of the person whom you want to refer.",
                    style: TextStyle(
                        fontFamily: "poppinsM",
                        fontSize: 12,
                        color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    onChanged: (val) {},
                    controller: memberNameController,
                    decoration: InputDecoration(
                      hintText: "Name",
                      counterText: "",
                      hintStyle:
                          const TextStyle(fontFamily: "poppinsM", fontSize: 12),
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  const SizedBox(
                    height: 11.5,
                  ),
                  TextField(
                    onChanged: (val) {},
                    controller: memberMobileController,
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Phone Number",
                      counterText: "",
                      hintStyle:
                          const TextStyle(fontFamily: "poppinsM", fontSize: 12),
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (memberNameController.text.trim() == "" ||
                          memberMobileController.text.trim() == "") {
                        Navigator.of(context).pop();

                        _showConfirmDialog(
                            false, "Please fill all the fields", context);
                      } else {
                        otpLoading = true;
                        setState(() => {});
                        final response = await ref
                            .read(moreControllerProvider.notifier)
                            .addReferral(memberNameController.text.trim(),
                                memberMobileController.text.trim(), context);
                        otpLoading = false;
                        setState(() => {});
                        memberNameController.text = "";
                        memberMobileController.text = "";
                        Navigator.of(context).pop();
                        if (response["success"] == true) {
                          _getReferrals();
                          _showConfirmDialog(
                              true, response["message"], context);
                        } else {
                          _showConfirmDialog(
                              false, response["message"], context);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: const Color.fromRGBO(139, 0, 0, 1),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: otpLoading
                        ? const SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ))
                        : const Text(
                            "ADD",
                            style: TextStyle(
                                fontFamily: "poppinsM",
                                fontSize: 14,
                                color: Colors.white),
                          ),
                  ),
                ],
              ),
            )),
          );
        });
      },
    );
  }

  _getReferrals() async {
    name = [];
    mobileNumber = [];
    final response = await ref
        .read(moreControllerProvider.notifier)
        .checkUserExists(context);
    name = response[0];
    mobileNumber = response[1];
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getReferrals();
  }

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddReferralDialog(context);
        },
        label: const Text('ADD'),
        icon: const Icon(Icons.add),
        backgroundColor: const Color.fromRGBO(139, 0, 0, 1),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white24,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              })),
      body: RefreshIndicator(
        onRefresh: () async {
          _getReferrals();
        },
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                Container(
                  height: 175,
                  margin: const EdgeInsets.only(right: 10, left: 10),
                  child: Image.asset("assets/images/referral.png"),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text('Refer a Friend',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: const Color.fromRGBO(139, 0, 0, 1),
                        fontSize: 20 / scaleFactor,
                        fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 10,
                ),
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      'On referring a person you both will get some discount coupons',
                      style: TextStyle(fontSize: 14 / scaleFactor),
                      textAlign: TextAlign.center,
                    )),
                const SizedBox(
                  height: 30,
                ),
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      'R E F E R R A L  T E A M',
                      style: TextStyle(
                          fontSize: 16 / scaleFactor,
                          color: const Color.fromRGBO(139, 0, 0, 1),
                          decoration: TextDecoration.underline,
                          decorationColor: const Color.fromRGBO(139, 0, 0, 1)),
                      textAlign: TextAlign.center,
                    )),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: !isLoading,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'S.No.',
                                  style: TextStyle(
                                      fontSize: 15 / scaleFactor,
                                      fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'Name',
                                  style: TextStyle(
                                      fontSize: 15 / scaleFactor,
                                      fontWeight: FontWeight.w800),
                                )
                              ],
                            ),
                            Text(
                              'Phone Number',
                              style: TextStyle(
                                  fontSize: 15 / scaleFactor,
                                  fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 0.5,
                        )
                      ],
                    ),
                  ),
                ),
                if (isLoading == false && name.isEmpty)
                  Text(
                    'No referrals',
                    style: TextStyle(
                        fontSize: 15 / scaleFactor, color: Colors.grey),
                  ),
                isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(30.0),
                          child: CircularProgressIndicator(
                              color: Color.fromRGBO(139, 0, 0, 1)),
                        ),
                      )
                    : Column(
                        children: List.generate(name.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                              fontSize: 14 / scaleFactor),
                                        ),
                                        const SizedBox(
                                          width: 50,
                                        ),
                                        Text(
                                          name[index],
                                          style: TextStyle(
                                              fontSize: 14 / scaleFactor),
                                        )
                                      ],
                                    ),
                                    Text(
                                      mobileNumber[index],
                                      style:
                                          TextStyle(fontSize: 14 / scaleFactor),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  thickness: 0.5,
                                )
                              ],
                            ),
                          );
                        }),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
