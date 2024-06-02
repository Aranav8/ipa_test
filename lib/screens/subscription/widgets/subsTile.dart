// ignore: file_names
import 'package:flutter/material.dart';
import 'package:ridobiko/screens/rental/BookingDetails.dart';
import 'package:ridobiko/data/subs_data.dart';

import '../../../data/BookingFlow.dart';

class SearchingTileSubs extends StatefulWidget {
  final SubsData data;
  const SearchingTileSubs(this.data);
  @override
  State<StatefulWidget> createState() {
    return Tile();
  }
}

class Tile extends State<SearchingTileSubs> {
  var _rent = '0';

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    if (BookingFlow.duration == '1') _rent = widget.data.rent1Month!;
    if (BookingFlow.duration == '2') _rent = widget.data.rent2Month!;
    if (BookingFlow.duration == '3') _rent = widget.data.rent3Month!;
    if (BookingFlow.duration == '6') _rent = widget.data.rent6Month!;
    if (BookingFlow.duration == '12') _rent = widget.data.rent12Month!;
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
                children: [
                  Expanded(
                      child: Column(
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
                        'Rs. $_rent/Month',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20 / scaleFactor,
                            fontWeight: FontWeight.bold),
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
                          return Image.network(
                            'https://www.ridobiko.com/images/default.png',
                            height: 80,
                          );
                        },
                      ),
                      InkWell(
                        onTap: () {
                          if (widget.data.available == 'yes') {
                            BookingFlow.selectedBikeSubs = widget.data;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Booking.withoutData()),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          // margin:EdgeInsets.only(right: 40,left: 40),
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
        Visibility(
          visible: false,
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            height: 160,
            width: MediaQuery.of(context).size.width,
            child: Expanded(
              child: Card(
                color: Colors.black.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        )
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
