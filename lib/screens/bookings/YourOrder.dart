// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridobiko/screens/bookings/CompletedTb.dart';
import 'package:ridobiko/screens/bookings/OngoingTb.dart';
import 'package:ridobiko/controllers/bookings/booking_controller.dart';
import 'package:ridobiko/data/BookingData.dart';
import 'package:url_launcher/url_launcher.dart';

class YourOrder extends ConsumerStatefulWidget {
  const YourOrder({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return order();
  }
}

// ignore: camel_case_types
class order extends ConsumerState {
  List<BookingData> ongoing = [];

  List<BookingData> completed = [];
  bool dataAvailable = true;
  bool dataAvailableCompleted = true;

  bool isLoading = false;
  @override
  void initState() {
    _getData();
    setState(() {
      isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:
            isLoading ? const CircularProgressIndicator() : null,
        appBar: AppBar(
          centerTitle: true,
          actions: [
            PopupMenuButton<int>(
              enabled: true,
              onSelected: (value) {
                if (value == 1) {
                  // ignore: deprecated_member_use
                  launch('https://www.ridobiko.com/Terms.php');
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                    value: 1,
                    child: Text("Policies",
                        style: TextStyle(fontSize: 14 / scaleFactor))),
              ],
              padding: const EdgeInsets.all(10),
              offset: const Offset(0, 50),
              color: Colors.white,
              elevation: 5,
            ),
          ],
          elevation: 0,
          backgroundColor: const Color.fromRGBO(139, 0, 0, 1),
          bottom: TabBar(
            indicatorColor: Colors.grey[200],
            padding: const EdgeInsets.symmetric(horizontal: 5),
            tabs: const [
              Tab(
                text: "Ongoing",
              ),
              Tab(
                text: "Completed",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OngoingTb(dataAvailable, ongoing, _getData),
            CompletedTb(dataAvailableCompleted, completed, _getData)
          ],
        ),
      ),
    );
  }

  Future<void> _getData() async {
    final response =
        await ref.read(bookingControllerProvider.notifier).getData(context);
    ongoing = response[0];
    if (ongoing.isEmpty) {
      dataAvailable = false;
    }

    completed = response[1];
    if (completed.isEmpty) {
      dataAvailableCompleted = false;
    }
    setState(() {});
  }
}
