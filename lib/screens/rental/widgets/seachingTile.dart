// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ridobiko/screens/rental/BookingDetails.dart';
import 'package:ridobiko/utils/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/BookingFlow.dart';

// ignore: must_be_immutable
class SearchingTile extends StatefulWidget {
  BikeData data;
  SearchingTile(this.data, {super.key});
  @override
  State<StatefulWidget> createState() {
    return Tile();
  }
}

class Tile extends State<SearchingTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 10,
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.data.bikeBrand} ',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.grey, fontSize: 16 / scaleFactor),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        '${widget.data.bikeName}',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20 / scaleFactor,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.black54,
                            size: 20,
                          ),
                          Text(
                            truncateText(widget.data.locality!, 22),
                            style: TextStyle(
                                fontSize: 14 / scaleFactor,
                                color: Colors.black54),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Rs. ${widget.data.actualRent}',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20 / scaleFactor),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text('Exclude fuel cost & GST',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13 / scaleFactor,
                          )),
                    ],
                  )),
                  Column(
                    children: [
                      Image.network(
                        widget.data.bikeImage.toString(),
                        height: 80,
                        errorBuilder: (context, exception, stackTrace) {
                          if (kDebugMode) {
                            print(
                              widget.data.bikeImage.toString(),
                            );
                          }
                          return Image.network(
                            'https://www.ridobiko.com/images/default.png',
                            height: 80,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      InkWell(
                        onTap: () async {
                          if (widget.data.available == 'yes') {
                            BookingFlow.selectedBike = widget.data;
                            BookingFlow.selectedBike!.pickup =
                                BookingFlow.pickup_date;
                            BookingFlow.selectedBike!.drop =
                                BookingFlow.drop_date;
                            var prefs = await SharedPreferences.getInstance();
                            await prefs.setString('recent_search',
                                jsonEncode(BookingFlow.selectedBike?.toJson()));
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Booking(
                                        BookingFlow.selectedBike,
                                      )),
                            );
                          } else {
                            Toast(context,
                                "Bike is already booked please try some other bike");
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: widget.data.available == 'yes'
                                  ? LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                          const Color.fromRGBO(139, 0, 0, 1),
                                          Colors.red[200]!
                                        ])
                                  : const LinearGradient(colors: [
                                      Colors.grey,
                                      Colors.grey,
                                    ])),
                          child: Row(
                            children: [
                              Text(
                                widget.data.available != 'yes'
                                    ? 'Booked'
                                    : 'Book ',
                                style: TextStyle(
                                  fontSize: 14 / scaleFactor,
                                  color: Colors.white,
                                ),
                              ),
                              widget.data.available == 'yes'
                                  ? const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                      size: 20,
                                    )
                                  : const Icon(
                                      Icons.done,
                                      color: Colors.white,
                                    )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String truncateText(String locality, int maxLength) {
    if (locality.length <= maxLength) {
      return locality;
    } else {
      final truncatedText = locality.substring(0, maxLength);
      return '$truncatedText...';
    }
  }
}
