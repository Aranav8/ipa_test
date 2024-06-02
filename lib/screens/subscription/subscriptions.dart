// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ridobiko/controllers/rental/rental_controller.dart';
import 'package:ridobiko/data/blog_data.dart';
import 'package:ridobiko/screens/subscription/select_city_subs.dart';

import 'package:ridobiko/screens/subscription/widgets/WhySubscriptions.dart';
import 'package:url_launcher/url_launcher.dart';
import '../rental/widgets/BlogSection.dart';
import '../rental/widgets/HappyCustomer.dart';
import '../rental/widgets/Spinner.dart';
// import '../rentalLayout/Tile.dart';

class Subscriptions extends ConsumerStatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final callBack;
  const Subscriptions(this.callBack, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return mySubscription();
  }
}

// ignore: camel_case_types
class mySubscription extends ConsumerState<Subscriptions> {
  List<Blog> _blogs = [];

  Color rentalBackgroundColor = const Color.fromRGBO(0, 0, 0, 0);
  Color subsBackgroundColor = Colors.white;
  @override
  void initState() {
    super.initState();
    _loadBlogsData();
  }

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

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
                        borderRadius: BorderRadius.circular(10.0),
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
                                  decoration: BoxDecoration(
                                    color: rentalBackgroundColor,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15.0),
                                    ),
                                  ),
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
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  subsBackgroundColor = Colors.white;
                                  rentalBackgroundColor =
                                      const Color.fromRGBO(0, 0, 0, 0);
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            20 /
                                            360),
                                height: 90.0,
                                decoration: BoxDecoration(
                                  color: subsBackgroundColor,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15.0),
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                              ),
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
                            "Subscription",
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                // fontFamily: 'Helvetica',
                                fontSize: 30.0 / scaleFactor),
                          ),
                          Text(
                            "Book bike rentals by the months & year",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0 / scaleFactor),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SelectCitySubs()),
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
                const SizedBox(height: 5),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  // padding: const EdgeInsets.only(left: 10.0,top: 20),

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
                          /// add widgets from here
                          Padding(
                            padding: const EdgeInsets.only(left: 16, top: 20),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Why Subsciptions',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20 / scaleFactor,
                                ),
                              ),
                            ),
                          ),

                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  child: WhySub(
                                    title: 'Flat discount on  monthly rental',
                                    trailingImage: Image.asset(
                                      "assets/images/discount.png",
                                      height: 30,
                                      color: Colors.black,
                                    ),
                                    color:
                                        const Color.fromRGBO(174, 227, 242, 1),
                                    cardColor:
                                        const Color.fromRGBO(218, 242, 249, 1),
                                    onTab: () {},
                                  ),
                                ),
                                WhySub(
                                  title: 'Premium customer benefits',
                                  trailingImage: Image.asset(
                                    "assets/images/premium.png",
                                    height: 30,
                                    color: Colors.black,
                                  ),
                                  color: const Color.fromRGBO(191, 255, 191, 1),
                                  cardColor:
                                      const Color.fromRGBO(211, 255, 211, 1),
                                  onTab: () {},
                                ),
                                WhySub(
                                  title: 'Price efficient Free ',
                                  trailingImage: Image.asset(
                                    "assets/images/price free.png",
                                    height: 30,
                                    color: Colors.black,
                                  ),
                                  color: const Color.fromRGBO(255, 196, 196, 1),
                                  cardColor:
                                      const Color.fromRGBO(255, 216, 216, 1),
                                  onTab: () {},
                                ),
                                WhySub(
                                  title: 'pickup and drop',
                                  trailingImage: Image.asset(
                                    "assets/images/subpickup.png",
                                    height: 30,
                                    color: Colors.black,
                                  ),
                                  color: const Color.fromRGBO(220, 220, 220, 1),
                                  cardColor:
                                      const Color.fromRGBO(245, 245, 245, 1),
                                  onTab: () {},
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'How it works',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20 / scaleFactor,
                                ),
                              ),
                            ),
                          ),
                          Card(
                            margin: const EdgeInsets.only(
                                right: 10, bottom: 20, top: 20, left: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            elevation: 10,
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                const SizedBox(
                                  height: 40,
                                ),
                                ListTile(
                                  leading: Image.asset(
                                      "assets/images/Select-Your-Vehicle.png"),
                                  title: Text(
                                    'Select a bike',
                                    style: TextStyle(
                                        fontSize: 14 / scaleFactor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                      'Pick a bike from 15+ models & tenure from 1-12 months',
                                      style: TextStyle(
                                          fontSize: 14 / scaleFactor)),
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(top: 20)),
                                ListTile(
                                  leading:
                                      Image.asset("assets/images/Paybook.png"),
                                  title: Text(
                                    'Pay & book',
                                    style: TextStyle(
                                        fontSize: 14 / scaleFactor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                      'Select the tenure and complete the booking',
                                      style: TextStyle(
                                          fontSize: 14 / scaleFactor)),
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(top: 20)),
                                ListTile(
                                  leading: Image.asset(
                                      "assets/images/vehiclepick.png"),
                                  title: Text(
                                    'Vehicle Pickup',
                                    style: TextStyle(
                                        fontSize: 14 / scaleFactor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                      'Visit the pickup location and collect the vehicle ',
                                      style: TextStyle(
                                          fontSize: 14 / scaleFactor)),
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(top: 20)),
                                ListTile(
                                  leading: Image.asset(
                                      "assets/images/Monthly-Billing.png"),
                                  title: Text(
                                    'Monthly billing',
                                    style: TextStyle(
                                        fontSize: 14 / scaleFactor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                      'Pay the booking amount as per convenience on monthly basis ',
                                      style: TextStyle(
                                          fontSize: 14 / scaleFactor)),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.only(left: 10.0),
                            margin: const EdgeInsets.only(
                                bottom: 10, left: 10, right: 10),
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
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Spinner(text: 'spinner')),
                          Container(
                            margin: const EdgeInsets.only(
                                bottom: 0, top: 20, left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "  Subscription vs buying",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 20 / scaleFactor,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),

                          Card(
                            margin: const EdgeInsets.only(
                                top: 20, right: 15, left: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            elevation: 10,
                            color: Colors.white,
                            child: Column(children: [
                              const Padding(
                                  padding:
                                      EdgeInsets.only(top: 10, bottom: 10)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    "Subscribe",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 15 / scaleFactor,
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    'Buy',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 15 / scaleFactor,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800]),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                              ListTile(
                                title: Text('Zero down payment ',
                                    style:
                                        TextStyle(fontSize: 14 / scaleFactor)),
                                trailing: const SizedBox(
                                  width: 100,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 50)),
                                      Icon(
                                        Icons.cancel_outlined,
                                        color: Colors.red,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Text('Annual insurance included ',
                                    style:
                                        TextStyle(fontSize: 14 / scaleFactor)),
                                trailing: const SizedBox(
                                  width: 100,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 50)),
                                      Icon(
                                        Icons.cancel_outlined,
                                        color: Colors.red,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Text('Free service & maintenance ',
                                    style:
                                        TextStyle(fontSize: 14 / scaleFactor)),
                                trailing: const SizedBox(
                                  width: 100,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 50)),
                                      Icon(
                                        Icons.cancel_outlined,
                                        color: Colors.red,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Text('return or extends anytimes',
                                    style:
                                        TextStyle(fontSize: 14 / scaleFactor)),
                                trailing: const SizedBox(
                                  width: 100,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 50)),
                                      Icon(
                                        Icons.cancel_outlined,
                                        color: Colors.red,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 15))
                            ]),
                          ),

                          Container(
                            padding: const EdgeInsets.only(left: 10.0),
                            margin: const EdgeInsets.fromLTRB(15, 20, 15, 10),
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
                          SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
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
                                        "Got this for 3 days,was well maintained had a amazing ride with this Scooty,Thank you Ridobiko-Bike Rental also the staff there was very helpful regarding timing and instructions",
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

                          Container(
                            margin: const EdgeInsets.only(
                                bottom: 10, left: 10, top: 10),
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
                                    launch('https://ridobiko.com/blog/');
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
                                      launchUrl(Uri.parse(data.link!));
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
