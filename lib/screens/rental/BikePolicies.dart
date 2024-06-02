// ignore_for_file: file_names

import 'package:flutter/material.dart';

class BikePolicies extends StatefulWidget {
  const BikePolicies({Key? key}) : super(key: key);

  @override
  State<BikePolicies> createState() => _BikePoliciesState();
}

class _BikePoliciesState extends State<BikePolicies> {
  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromRGBO(139, 0, 0, 1),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: const EdgeInsets.only(right: 30, left: 30, top: 10),
                  padding: const EdgeInsets.only(bottom: 10),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Color.fromRGBO(139, 0, 0, 1), width: 1))),
                  child: Align(
                    child: Text(
                      "P O L I C I E S",
                      style: TextStyle(
                          fontSize: 20 / scaleFactor,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromRGBO(139, 0, 0, 1)),
                    ),
                  )),
              Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(
                        color: const Color.fromRGBO(139, 0, 0, 1),
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ' Cancellation: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18 / scaleFactor),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: Text(
                                  style: TextStyle(fontSize: 14 / scaleFactor),
                                  textAlign: TextAlign.start,
                                  "No show during pick - 100% rent amount will be deducted and only security deposit will be refunded (If paid in advance by customer) Between 0 - 24 hrs before the pickup time - No cancellation & 100% amount will be deducted.Between 24-48 hrs before the pickup time: 75% of total booking amount or total amount paid whichever will lower)More than 48hrs before the pickup time: 50% of total booking amount or total amount paid whichever is lower will berefunded. ")),
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.black54,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '  Late Return: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18 / scaleFactor),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: Text(
                                  textAlign: TextAlign.start,
                                  "Non Geared Scooters: First 2 hours of delay would be charged at ₹100 + more than 2 hr full day rent will be chargedGeared two wheeler: First 2 hours of delay would be charged at ₹200 + more than 2 hr full day rent will be chargedPost 2 Hours:, Above hourly charges will be applicable on weekdays (Mon–Fri)",
                                  style:
                                      TextStyle(fontSize: 14 / scaleFactor))),
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.black54,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Accident Policy:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18 / scaleFactor),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Text(
                                  textAlign: TextAlign.start,
                                  "For any damages incurred to an Ridobiko asset (the two-wheeler), the user will be held responsible for bearing all the charges up to INR ₹10,000.For any damages incurred to an Ridobiko asset (the two-wheeler) amounting more than INR ₹10,000, the user is eligible to claim insurance to cover the charges that imply including the rental cost incurred during downtime period of the asset which is a time period otherwise utilized by another Ridobiko user ",
                                  style:
                                      TextStyle(fontSize: 14 / scaleFactor))),
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.black54,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '   Penalties :   ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18 / scaleFactor),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                              child: Text(
                                  textAlign: TextAlign.start,
                                  "Penalty for damaging",
                                  style:
                                      TextStyle(fontSize: 14 / scaleFactor))),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
