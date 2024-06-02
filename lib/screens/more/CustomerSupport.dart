// ignore_for_file: file_names, deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ridobiko/utils/snackbar.dart';
import 'package:ridobiko/controllers/more/more_controller.dart';
import 'package:ridobiko/data/raise_issue_data.dart';
import 'package:url_launcher/url_launcher.dart';

class Customer extends ConsumerStatefulWidget {
  const Customer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return Support();
  }
}

class Support extends ConsumerState {
  String hintText = "Write your  concern";
  String dropdownValue = 'Select Issue';
  List<RaiseIssueData> issues = [];
  bool isLoading = true;

  List<String> spinnerItems = [
    'Select Issue',
    'Booking Issue',
    'Corporate Banking',
    'Careers',
    'Drop related',
    'Dealer Issue',
    'Payment and Refund',
    'Suggestion',
    'Security deposit refund'
  ];

  var txt = TextEditingController();

  bool _otherVisibility = false;

  var comment = TextEditingController();
  @override
  void initState() {
    _getDataFromAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;
    bool pb = ref.watch(moreControllerProvider);

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white24,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              })),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.,
          children: [
            Container(
              height: 150,
              margin: const EdgeInsets.only(right: 10, left: 10),
              child: SvgPicture.asset("assets/images/support.svg"),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
                child: Text('Customer Support',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: const Color.fromRGBO(139, 0, 0, 1),
                        fontSize: 20 / scaleFactor,
                        fontWeight: FontWeight.bold))),
            const SizedBox(
              height: 10,
            ),
            Align(
                alignment: Alignment.center,
                child: Text('Just One Tap Away From Our Customer Support',
                    style: TextStyle(fontSize: 14 / scaleFactor))),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      _makingPhoneCall();
                    },
                    child: Image.asset(
                      "assets/images/telephone.png",
                      height: 40,
                      color: const Color.fromRGBO(139, 0, 0, 1),
                    )),
                const SizedBox(
                  width: 30,
                ),
                GestureDetector(
                    onTap: () {
                      openwhatsapp();
                    },
                    child: Image.asset(
                      "assets/images/whatsapp.png",
                      height: 44,
                      color: const Color.fromRGBO(139, 0, 0, 1),
                    )),
              ],
            ),
            GestureDetector(
              onTap: () {
                _makingPhoneCall();
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(
                    top: 10, bottom: 10, right: 90, left: 90),
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(139, 0, 0, 1),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.phone_android,
                      color: Colors.white,
                    ),
                    const Padding(padding: EdgeInsets.only(left: 15)),
                    Text(
                      '+91 9971770131',
                      style: TextStyle(
                          color: Colors.white, fontSize: 14 / scaleFactor),
                    )
                  ],
                ),
              ),
            ),
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
                          color: Colors.grey, fontSize: 14 / scaleFactor)),
                ),
                Expanded(
                  child: Container(
                    height: 0.5,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.0),
                    ),
                  ),
                  builder: (BuildContext bcontext) {
                    return StatefulBuilder(
                      builder: (BuildContext context,
                          void Function(void Function()) setState) {
                        return Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Card(
                                margin: const EdgeInsets.all(20),
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Color.fromRGBO(139, 0, 0, 1),
                                      width: 0.5),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Wrap(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 20, right: 20, left: 20),
                                      padding: const EdgeInsets.only(left: 10),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          border: Border.all(
                                              color: Colors.grey, width: 0.5)),
                                      child: Column(
                                        children: [
                                          DropdownButton<String>(
                                            value: dropdownValue,
                                            elevation: 0,
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
                                            iconSize: 24,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18 / scaleFactor),
                                            onChanged: (data) {
                                              dropdownValue = data!;
                                              if (data == 'Others') {
                                                _otherVisibility = true;
                                              } else {
                                                _otherVisibility = false;
                                              }
                                              setState(() {});
                                            },
                                            items: spinnerItems
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value,
                                                    style: TextStyle(
                                                        fontSize:
                                                            14 / scaleFactor)),
                                              );
                                            }).toList(),
                                          ),
                                          Visibility(
                                            visible: _otherVisibility,
                                            child: TextField(
                                              controller: txt,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              textAlign: TextAlign.left,
                                              textInputAction:
                                                  TextInputAction.done,
                                              decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                      fontSize:
                                                          14 / scaleFactor,
                                                      color: Colors.grey),
                                                  enabledBorder:
                                                      const OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color:
                                                                  Colors.grey,
                                                              width: 0.5),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      10))),
                                                  border: InputBorder.none,
                                                  focusedBorder:
                                                      const OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 0.5),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(10))),
                                                  hintText: "Input Reason"),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Directionality(
                                            textDirection: TextDirection.ltr,
                                            child: Focus(
                                                onFocusChange: (hasFocus) {
                                                  if (hasFocus) {
                                                    setState(() {});
                                                    hintText = "";
                                                  } else {
                                                    setState(() {});
                                                    hintText =
                                                        "Write your  concern";
                                                  }
                                                },
                                                child: TextField(
                                                  controller: comment,
                                                  maxLines: 4,
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  textAlign: TextAlign.left,
                                                  decoration: InputDecoration(
                                                      hintStyle: TextStyle(
                                                          fontSize:
                                                              14 / scaleFactor,
                                                          color: Colors.grey),
                                                      enabledBorder: const OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color:
                                                                  Colors.grey,
                                                              width: 0.5),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      10))),
                                                      border: InputBorder.none,
                                                      focusedBorder: const OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 0.5),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(10))),
                                                      hintText: hintText),
                                                ))),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              InkWell(
                                onTap: () {
                                  _raiseIssue();
                                  Navigator.pop(bcontext);
                                },
                                child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(22),
                                        gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              const Color.fromRGBO(
                                                  139, 0, 0, 1),
                                              Colors.red[200]!
                                            ])),
                                    child: Center(
                                      child: pb
                                          ? const SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            )
                                          : Text(
                                              'Submit',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15 / scaleFactor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                    )),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.only(
                    top: 10, bottom: 20, right: 90, left: 90),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border:
                        Border.all(color: const Color.fromRGBO(139, 0, 0, 1))),
                child: Text(
                  'Raise Ticket',
                  style: TextStyle(fontSize: 14 / scaleFactor),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(14.0),
                      child: CircularProgressIndicator(
                          color: Color.fromRGBO(139, 0, 0, 1)),
                    ),
                  )
                : issues.isEmpty
                    ? Text(
                        "No Issue Found",
                        style: TextStyle(
                            fontSize: 14 / scaleFactor, color: Colors.grey),
                      )
                    : Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: issues.length,
                            itemBuilder: (bcontext, pos) {
                              var data = issues[pos];
                              return Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.grey, width: 0.5),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 10,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                data.ticketId!,
                                                style: TextStyle(
                                                    fontSize: 14 / scaleFactor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Status :",
                                                style: TextStyle(
                                                    fontSize: 14 / scaleFactor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(data.status!,
                                                  style: TextStyle(
                                                      fontSize:
                                                          14 / scaleFactor))
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Issues Type : ",
                                                style: TextStyle(
                                                    fontSize: 12 / scaleFactor),
                                              ),
                                              Text(
                                                data.issueType!,
                                                style: TextStyle(
                                                    fontSize: 12 / scaleFactor),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Created on :",
                                                style: TextStyle(
                                                    fontSize: 12 / scaleFactor),
                                              ),
                                              Text(
                                                data.createdOn!,
                                                style: TextStyle(
                                                    fontSize: 12 / scaleFactor),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Divider(
                                        thickness: 0.5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Note: ",
                                            style: TextStyle(
                                                fontSize: 14 / scaleFactor,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(data.comment!,
                                              style: TextStyle(
                                                  fontSize: 14 / scaleFactor)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getDataFromAPI() async {
    issues = [];
    issues =
        await ref.read(moreControllerProvider.notifier).getDataFromAPI(context);
    isLoading = false;
    setState(() {});
  }

  _makingPhoneCall() async {
    var url = Uri.parse("tel:9971770131");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  openwhatsapp() async {
    var whatsapp = "+919971770131";
    var whatsappurlAndroid = "whatsapp://send?phone=$whatsapp";

    // android , web
    if (await canLaunch(whatsappurlAndroid)) {
      await launch(whatsappurlAndroid);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("whatsapp no installed")));
    }
  }

  Future<void> _raiseIssue() async {
    bool response = await ref.read(moreControllerProvider.notifier).raiseIssue(
        dropdownValue == 'Others'
            ? txt.text.toString()
            : dropdownValue.toString(),
        comment.text.toString(),
        context);

    if (response) {
      Toast(context, "Ticket Raised successfully");
      _getDataFromAPI();
    }
  }
}
