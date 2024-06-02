import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridobiko/controllers/subscription/subscription_controller.dart';
import 'package:ridobiko/data/BookingFlow.dart';
import 'package:ridobiko/data/city_data.dart';

import 'Subsearch.dart';

class SelectCitySubs extends ConsumerStatefulWidget {
  const SelectCitySubs({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _selectCityPage();
  }
}

// ignore: camel_case_types
class _selectCityPage extends ConsumerState<SelectCitySubs> {
  List<CityData> _cities = [];

  var pos = 0;
  String selected = "";
  @override
  void initState() {
    BookingFlow.fromMore = false;
    super.initState();
    _fetchCities();
  }

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.keyboard_arrow_left,
                            size: 40,
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Select City",
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 24 / scaleFactor),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Available Cities",
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                          fontSize: 18 / scaleFactor),
                    ),
                  ),
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Visibility(
                        visible: _cities.isNotEmpty,
                        child: Card(
                          elevation: 5,
                          margin: const EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (builder, i) {
                                return _otherCity(_cities.elementAt(i));
                              },
                              itemCount: _cities.length,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Visibility(
                            visible: _cities.isEmpty,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Loading Cities...Please wait',
                                  style: TextStyle(
                                    fontSize: 18 / scaleFactor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const SizedBox(
                                  height: 26,
                                  width: 26,
                                  child: CircularProgressIndicator(
                                    color: Color.fromRGBO(139, 0, 0, 1),
                                  ),
                                )
                              ],
                            )),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _otherCity(CityData name) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        selected = name.city_name!;
        BookingFlow.city = selected;
        BookingFlow.cityData = name;
        setState(() {});
        Navigator.push(context,
            MaterialPageRoute(builder: (builder) => const SubSearch()));
      },
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    name.city_name!,
                    style: TextStyle(
                        fontSize: 16,
                        color: selected == name.city_name!
                            ? Colors.red[700]
                            : Colors.black),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              height: 1,
              color: Colors.grey[200],
            ),
          )
        ],
      ),
    );
  }

  void _fetchCities() async {
    _cities = await ref
        .read(subscriptionControllerProvider.notifier)
        .fetchCities(context);
    setState(() {});
  }
}
