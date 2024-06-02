// ignore_for_file: file_names

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Spinner extends StatefulWidget {
  String text;

  Spinner({super.key, required this.text});

  @override
  mySpinner createState() => mySpinner();
}

// ignore: camel_case_types
class mySpinner extends State {
  String descText =
      "Yes, each vehicle comes with a speed limit mentioned with the vehicle terms and conditions";
  String secondText =
      "Yes,  extensions are possible subject to availability & charges.Cancellations & modifi-cations will attract nominal charges as per our";
  String thirdText =
      "You need a valid aadhar card and driving license to avail services \nNote:One original ID will be submitted during pickup";
  String fourthText =
      "Restricted area depends on the city and will be communicated to you during pickup";
  bool secondShowFlag = false;
  bool descTextShowFlag = false;
  bool thirdTextShowFlag = true;
  bool fourthTextShowFlag = false;

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return SizedBox(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 10,
        color: Colors.white,
        child: Column(children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(15, 15, 15, 8),
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  // direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Is there a speed limit?',
                        style: TextStyle(
                            fontSize: 15 / scaleFactor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Padding(padding: EdgeInsets.only(left: 80)),
                    Container(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            descTextShowFlag = !descTextShowFlag;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            descTextShowFlag
                                ? const Icon(
                                    Icons.keyboard_arrow_up,
                                    size: 30,
                                    color: Colors.grey,
                                  )
                                : const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 30,
                                    color: Colors.grey,
                                  )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (descTextShowFlag)
                  Text(descText,
                      maxLines: descTextShowFlag ? 8 : 1,
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 14 / scaleFactor)),
              ],
            ),
          ),

          // second----------------------------------------------------------------------------------------------------
          const Divider(
            thickness: 0.5,
          ),

          Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.fromLTRB(15, 8, 15, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Can I extend/cancel/modify?',
                        style: TextStyle(
                            fontSize: 15 / scaleFactor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            secondShowFlag = !secondShowFlag;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            secondShowFlag
                                ? const Icon(
                                    Icons.keyboard_arrow_up,
                                    size: 30,
                                    color: Colors.grey,
                                  )
                                : const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 30,
                                    color: Colors.grey,
                                  )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (secondShowFlag)
                  Text(secondText,
                      maxLines: secondShowFlag ? 8 : 1,
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 14 / scaleFactor)),
              ],
            ),
          ),
          // third---------------------------------------------------------------------------------------------------------------------
          const Divider(
            thickness: 0.5,
          ),

          Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.fromLTRB(15, 8, 15, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Booking criteria & document?',
                        style: TextStyle(
                            fontSize: 15 / scaleFactor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            thirdTextShowFlag = !thirdTextShowFlag;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            thirdTextShowFlag
                                ? const Icon(
                                    Icons.keyboard_arrow_up,
                                    size: 30,
                                    color: Colors.grey,
                                  )
                                : const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 30,
                                    color: Colors.grey,
                                  )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (thirdTextShowFlag)
                  RichText(
                    text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(text: thirdText.substring(0, 68)),
                          TextSpan(
                              text: thirdText.substring(68),
                              style: TextStyle(
                                  fontSize: 14 / scaleFactor,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red))
                        ]),
                    maxLines: thirdTextShowFlag ? 8 : 1,
                    textAlign: TextAlign.start,
                  ),
              ],
            ),
          ),

          // fourth---------------------------------------------------------------------------------------
          const Divider(
            thickness: 0.5,
          ),
          Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.fromLTRB(15, 8, 15, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Are there any restricted areas?',
                        style: TextStyle(
                            fontSize: 15 / scaleFactor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            fourthTextShowFlag = !fourthTextShowFlag;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            fourthTextShowFlag
                                ? const Icon(
                                    Icons.keyboard_arrow_up,
                                    size: 30,
                                    color: Colors.grey,
                                  )
                                : const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 30,
                                    color: Colors.grey,
                                  )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (fourthTextShowFlag)
                  Text(fourthText,
                      maxLines: fourthTextShowFlag ? 8 : 1,
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 14 / scaleFactor)),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
