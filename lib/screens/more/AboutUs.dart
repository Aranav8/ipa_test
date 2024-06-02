// ignore_for_file: deprecated_member_use, duplicate_ignore, file_names

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<StatefulWidget> createState() {
    return About();
  }
}

class About extends State {
  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(139, 0, 0, 1),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
      ),
      body: SingleChildScrollView(
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'Get to know us',
                style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 27 / scaleFactor,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                textAlign: TextAlign.center,
                'Subscribe  a bike of your choice starting \n from 1 month to 12 months \n with no Strings attached! Own a great experience\n with Ridobiko',
                style: TextStyle(
                    color: Colors.grey[700], fontSize: 15 / scaleFactor),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Colors.grey[300],
              ),
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            style: const TextStyle(color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'R',
                                style: TextStyle(
                                    color: const Color.fromRGBO(139, 0, 0, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30 / scaleFactor),
                              ),
                              const TextSpan(
                                  text:
                                      ("idobiko's  fate was written when the  idea to rent bike penetrated Rajat’s mind. In the late 2015  Rajat started the concept of renting bikes making the life of many youngsters and bike trip enthusiasts in IIT Roorkee easier. Initial process was through a mobile application and the remaining link was connected manually. Noticing the chance to do good for the society and the potential the concept had, he decided to make it big. He was in search for a team of likeminded individuals with varying skill sets, which he found in IIT Roorkee itself. A group of 5 over enthusiastic and hyperactive individuals, this formed our team. We all tuned our mind to achieve one objective “creating a seamless platform for the consumers and vendors, which will provide a hassle free and effortless bike renting experience”. We understood the problems a consumer faced while renting bike and made sure that we solved everyone of them through RidoBIko. Booking a bike through RidoBiko is the easiest thing you would have ever done. Just signup to be part of our community of bike riding enthusiasts, select the bike you want and woof your ride is ready to mount. RidoBiko ensures transparency in every step and provides the highest level of service achievable. Join our community, enjoy the thrill of riding through the hills of India or enjoy the serenity of long drives with your partner."))
                            ])),
                  ]),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.grey[800],
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                            onTap: () {
                              _makingPhoneCall();
                            },
                            child: Image.asset(
                              "assets/images/telephone.png",
                              height: 40,
                              color: Colors.white,
                            )),
                        GestureDetector(
                            onTap: () {
                              // ignore: deprecated_member_use
                              launch("https://www.ridobiko.com/");
                            },
                            child: Image.asset(
                              "assets/images/web.png",
                              height: 40,
                              color: Colors.white,
                            )),
                        GestureDetector(
                            onTap: () {
                              openwhatsapp();
                            },
                            child: Image.asset(
                              "assets/images/whatsapp.png",
                              height: 40,
                              color: Colors.white,
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      '© 2021 Ridobiko Solutions Private Limited | All Rights Reserved',
                      style: TextStyle(
                          color: Colors.white, fontSize: 10 / scaleFactor),
                    )
                  ]),
            )
          ],
        ),
      ),
    );
  }
}

_makingPhoneCall() async {
  var url = Uri.parse("tel:9971710131");
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

openwhatsapp() async {
  var whatsapp = "+919971710131";
  var whatsappurlAndroid = "whatsapp://send?phone=$whatsapp";

  // android , web
  if (await canLaunch(whatsappurlAndroid)) {
    await launch(whatsappurlAndroid);
  }
}
