// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ridobiko/controllers/auth/auth_controller.dart';
import 'package:ridobiko/controllers/rental/rental_controller.dart';
import 'package:ridobiko/data/BookingFlow.dart';
import 'package:ridobiko/data/blog_data.dart';
import 'package:ridobiko/screens/rental/select_city.dart';
import 'package:ridobiko/screens/rental/widgets/BlogSection.dart';
import 'package:ridobiko/screens/rental/widgets/HappyCustomer.dart';
import 'package:ridobiko/screens/rental/widgets/Spinner.dart';
import 'package:ridobiko/screens/rental/widgets/WhyRidobiko.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../data/whats_data.dart';

// ignore: must_be_immutable
class Rental extends ConsumerStatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final callBack;
  BuildContext? homeContext;
  Rental(this.callBack, {super.key, this.homeContext});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return myHome();
  }
}

// ignore: camel_case_types
class myHome extends ConsumerState<Rental> {
  Color rentalBackgroundColor = Colors.white;
  Color subsBackgroundColor = const Color.fromRGBO(0, 0, 0, 0);
  List<WhatsData> list = [];
  BikeData? recent = BikeData.fromJson({});
  //var _recentAvailable = false;

  List<Blog> _blogs = [];

  @override
  void initState() {
    _loadWhatsNewData();
    _loadBlogsData();
    _getRecent();
    BookingFlow.selectedBikeSubs = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double scaleFactor = MediaQuery.textScaleFactorOf(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                const Color.fromRGBO(139, 0, 0, 1),
                Colors.red[200]!
              ])),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 40,
                    color: Colors.white,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Card(
                      elevation: 15,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: Colors.grey[200],
                        ),
                        padding: const EdgeInsets.all(10),
                        height: 100,
                        // color: Colors.grey[200],

                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            InkWell(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    rentalBackgroundColor = Colors.white;
                                    subsBackgroundColor =
                                        const Color.fromRGBO(0, 0, 0, 0);
                                    widget.callBack(0);
                                  });
                                },
                                child: Container(
                                    padding: const EdgeInsets.only(
                                        right: 20, left: 30),
                                    margin: const EdgeInsets.only(right: 5.0),
                                    height: 90.0,
                                    // ignore: sort_child_properties_last
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Rentals",
                                            style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 20.0 / scaleFactor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Flexible(
                                            child: Text(
                                              "    For days     ",
                                              style: TextStyle(
                                                  // color: Colors.black,
                                                  fontSize: 15.0 / scaleFactor),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: rentalBackgroundColor,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(15.0),
                                      ),
                                    )),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  subsBackgroundColor = Colors.white;
                                  rentalBackgroundColor =
                                      const Color.fromRGBO(0, 0, 0, 0);
                                  widget.callBack(1);
                                });
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              20 /
                                              360),
                                  height: 90.0,
                                  // ignore: sort_child_properties_last
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Subscription",
                                          style: GoogleFonts.poppins(
                                              fontSize: 20.0 / scaleFactor,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Flexible(
                                          child: Text(
                                            "For months & years",
                                            style: TextStyle(
                                                fontSize: 15.0 / scaleFactor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: subsBackgroundColor,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15.0),
                                    ),
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),

                    // SizedBox(height: 10.0),

                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Rentals",
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                // fontFamily: 'Helvetica',
                                fontSize: 30.0 / scaleFactor),
                          ),
                          Text(
                            "Book bike rentals by the days",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0 / scaleFactor),
                          ),
                        ],
                      ),
                    ),

                    // SizedBox(height: 10.0),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SelectCity()),
                        );
                      },
                      child: Container(
                        height: 70.0,
                        margin: const EdgeInsets.only(
                            top: 20.0, right: 20.0, left: 20.0),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Icon(Icons.location_on_rounded,
                                size: 50, color: Color.fromRGBO(139, 0, 0, 1)),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "Select city to search",
                                style: TextStyle(
                                    fontSize: 18 / scaleFactor,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[600]),
                              ),
                            ),
                            Image.asset(
                              "assets/images/arrow.png",
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(246, 244, 241, 1),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25.0),
                          topLeft: Radius.circular(25.0))),
                  child: Container(
                      margin: const EdgeInsets.only(right: 3),
                      color: Colors.transparent,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(left: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "What's New",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 20 / scaleFactor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (list.isEmpty)
                            Shimmer.fromColors(
                              baseColor: Colors.grey[400]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: 148,
                                width: 600,
                                margin: const EdgeInsets.all(15),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black45,
                                      blurRadius: 10,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          if (list.isNotEmpty)
                            SizedBox(
                              height: 180,
                              child: PageView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: list.length,
                                itemBuilder: (bcontext, pos) {
                                  var data = list[pos];
                                  return whyRido(
                                      title: data.title ?? "No Title",
                                      subtitle: data.content ?? "No content",
                                      trailingImage: data.imageUrl ?? "nothing",
                                      color: Colors.white,
                                      onTab: () async {
                                        if (list[pos].adUrl != null) {
                                          try {
                                            if (await canLaunchUrl(
                                                data.adUrl! as Uri)) {
                                              await launchUrl(
                                                  data.adUrl! as Uri);
                                            } else {
                                              throw 'Could not launch ${data.adUrl!}';
                                            }
                                          } catch (e) {
                                            print('Error launching URL: $e');
                                          }
                                        }
                                      });
                                },
                              ),
                            ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "FAQs",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 20 / scaleFactor,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // ignore: deprecated_member_use
                                    launch(
                                        'https://www.ridobiko.com/Terms.php');
                                  },
                                  child: Text(
                                    'View all',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 14 / scaleFactor,
                                        color: Colors.red),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              child: Spinner(text: 'spinner')),
                          Container(
                            margin: const EdgeInsets.only(top: 20, left: 16),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Happy Customers',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20 / scaleFactor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 255,
                            child: SingleChildScrollView(
                                physics: const ScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    HappyCust(
                                      title: 'Kanveer Dixit',
                                      subtitle:
                                          'Go for it guys, my experience was great. The condition of bike was perfect and they give amazing discount. Highly recommended.',
                                      color: Colors.white,
                                      onTab: () {},
                                    ),
                                    HappyCust(
                                      title: 'Prashant Shinde',
                                      subtitle:
                                          "Got this for 3 days,was well maintained had a amazing ride with this Scooty,Thank you Ridobiko-Bike Rental also the staff there was very helpful regarding timing and instructions.",
                                      color: Colors.white,
                                      onTab: () {},
                                    ),
                                    HappyCust(
                                      title: 'Abhishek Singh',
                                      subtitle:
                                          "I have taken an electric scooter from them on rent and the whole process was very easy and flawless the quality of service is also exceptional",
                                      color: Colors.white,
                                      onTab: () {},
                                    ),
                                    HappyCust(
                                      title: 'Aman Verma',
                                      subtitle:
                                          "The staffs are very cooperating, helped me out to rent proper bikes, and explained terms and policies very clearly. the bike's condition was also good. Impressed by Ridobiko's work.",
                                      color: Colors.white,
                                      onTab: () {},
                                    ),
                                    HappyCust(
                                      title: 'Yogesh Verma',
                                      subtitle:
                                          "My experience with Ridobiko was amazing I got the bike in very less time and the price was also very less. Ridobiko's Customer support services are also good.",
                                      color: Colors.white,
                                      onTab: () {},
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                bottom: 10, left: 16, right: 16, top: 15),
                            padding: const EdgeInsets.only(right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Blogs",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 20 / scaleFactor,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    launchUrlString(
                                        'https://ridobiko.com/blog/');
                                  },
                                  child: Text(
                                    'View all',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 14 / scaleFactor,
                                        color: Colors.red),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 220,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _blogs.length,
                                itemBuilder: (itemBuilder, pos) {
                                  var data = _blogs[pos];
                                  return BlogSection(
                                    title: data.title!,
                                    subtitle: '( ${data.category!} )',
                                    onTab: () {
                                      launchUrlString(data.link!);
                                    },
                                    trailingImage: data.postImg!,
                                    color: Colors.transparent,
                                  );
                                }),
                          )
                        ],
                      )),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: [
                            Image.asset(
                              'assets/icons/rating.png',
                              height: 50,
                              color: const Color.fromRGBO(139, 0, 0, 1)
                                  .withOpacity(0.8),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          child: ListTile(
                            title: Text(
                              'Highest rated',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18 / scaleFactor),
                            ),
                            subtitle: Text(
                              'self- drive bike rental and \nsubscription service in india',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14 / scaleFactor,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          "4.7",
                          style: TextStyle(
                              color: const Color.fromRGBO(139, 0, 0, 1)
                                  .withOpacity(0.8),
                              fontWeight: FontWeight.bold,
                              fontSize: 30 / scaleFactor),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showVerificationDialog(
      BuildContext mainContext, String message) async {
    return showDialog(
      context: widget.homeContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: const Text(
            'Verify Yourself',
            style: TextStyle(fontFamily: "poppinsM"),
          ),
          content: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  message,
                  style: const TextStyle(
                      fontSize: 12, color: Color.fromARGB(255, 69, 69, 69)),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(139, 0, 0, 1),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: const Text(
                    "Verify",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 224, 224, 224),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 182, 182, 182)),
                  ),
                ),
              ],
            ),
          )),
        );
      },
    );
  }

  Future<void> _loadWhatsNewData() async {
    try {
      list = await ref
          .read(rentalControllerProvider.notifier)
          .loadWhatsNewData(context);
      await ref.read(authControllerProvider.notifier).getUserDetails();
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _getRecent() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('recent_search')) {
      recent =
          BikeData.fromJson(jsonDecode(prefs.getString('recent_search') ?? ""));
    }
    setState(() {});
  }

  void _loadBlogsData() async {
    try {
      _blogs = await ref
          .read(rentalControllerProvider.notifier)
          .loadBlogsData(context);
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
