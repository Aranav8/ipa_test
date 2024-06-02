// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridobiko/controllers/subscription/subscription_controller.dart';

import 'package:ridobiko/data/BookingFlow.dart';
import 'package:ridobiko/screens/subscription/widgets/subsTile.dart';
import 'package:ridobiko/data/subs_data.dart';

import '../rental/MyHomePage.dart';

class SubProduct extends ConsumerStatefulWidget {
  final bool filter;
  const SubProduct(this.filter, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return subProduct();
  }
}

// ignore: camel_case_types
class subProduct extends ConsumerState<SubProduct> {
  List<SubsData> list = [];

  var count = 0;

  @override
  void initState() {
    if (!widget.filter) {
      _fetchBikes();
    } else {
      _getFiltered();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(children: [
              Container(
                color: Colors.white,
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                margin: const EdgeInsets.only(bottom: 10),
                width: double.infinity,
                height: 145,
                color: Colors.white,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Available Bikes",
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20 / scaleFactor),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: InkWell(
                              onTap: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MyHomePage()),
                                    (route) => false);
                              },
                              child: const Icon(
                                Icons.home,
                                size: 28,
                              )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(top: 10, right: 10, left: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    height: 72,
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '${BookingFlow.city}',
                            style: TextStyle(
                                fontSize: 20 / scaleFactor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 10)),
                        Row(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                '${BookingFlow.pickup_date}',
                                style: TextStyle(
                                    fontSize: 12 / scaleFactor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '$count Bikes available ',
                        style: TextStyle(
                            fontSize: 18 / scaleFactor,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  SizedBox(
                    // color: Colors.black,
                    height: MediaQuery.of(context).size.height - 220,
                    child: ListView.builder(
                        padding: const EdgeInsets.only(top: 10),
                        itemCount: list.length,
                        itemBuilder: (itemBuilder, pos) {
                          return SearchingTileSubs(list[pos]);
                        }),
                  ),
                  Visibility(
                      visible: list.isEmpty,
                      child: Column(
                        children: [
                          Text('Loading Bikes...Please wait',
                              style: TextStyle(
                                fontSize: 18 / scaleFactor,
                                fontWeight: FontWeight.w500,
                              )),
                          const SizedBox(
                            height: 7,
                          ),
                          const SizedBox(
                            height: 26,
                            width: 26,
                            child: CircularProgressIndicator(
                              color: Color.fromRGBO(139, 0, 0, 1),
                            ),
                          )
                        ],
                      ))
                ],
              )
            ]),
          ),
        ));
  }

  void _fetchBikes() async {
    final response = await ref
        .read(subscriptionControllerProvider.notifier)
        .fetchBikes(context);
    if (kDebugMode) {
      print(response);
    }
    count = response[0][0];
    list = response[1].cast<SubsData>();
    setState(() {});
  }

  void _getFiltered() {
    if (BookingFlow.selectedBrands.isNotEmpty) {
      for (var bike in BookingFlow.available_bikes_subs!) {
        if (BookingFlow.selectedBrands.contains(bike.bikeBrand)) {
          list.add(bike);
        }
      }
    } else {
      list.addAll(BookingFlow.available_bikes_subs!);
    }
    if (BookingFlow.price == 'Low to High') {
      list.sort((a, b) =>
          int.parse(a.rent1Month!).compareTo(int.parse(b.rent1Month!)));
    }
    if (BookingFlow.price == 'High to Low') {
      list.sort((a, b) =>
          int.parse(b.rent1Month!).compareTo(int.parse(a.rent1Month!)));
    }
    for (var i in list) {
      if (i.available == '1') count++;
    }
    setState(() {});
  }
}

BoxDecoration textBorder() {
  return BoxDecoration(
      border: Border.all(color: Colors.black45, width: 1.0),
      borderRadius: const BorderRadius.all(Radius.circular(10)));
}
