// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ridobiko/controllers/rental/rental_controller.dart';
import 'package:ridobiko/data/BookingFlow.dart';
import 'package:ridobiko/screens/subscription/SubProductPage.dart';
import '../rental/MyHomePage.dart';
import '../../data/city_data.dart';
import 'select_city_subs.dart';

class SubSearch extends ConsumerStatefulWidget {
  const SubSearch({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _searchPage();
  }
}

// ignore: camel_case_types
class _searchPage extends ConsumerState<SubSearch> {
  var months = [
    "Jan",
    "Feb",
    "March",
    "April",
    "May",
    "June",
    "Jul",
    "Aug",
    "Sept",
    "Oct",
    "Nov",
    "Dec"
  ];

  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedStartTime = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();
  DateTime _selectedEndTime = DateTime.now();
  var selectedTime = TimeOfDay.now();
  var weeks = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  String? _selectedCity;
  CityData cityData = BookingFlow.cityData!;
  var dropdownValue = '1';
  @override
  void initState() {
    super.initState();
  }

  Future<void> _showImageSourceDialog(
      BuildContext mainContext, String title, String description) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: Text(
            title,
          ),
          content: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  description,
                  style: const TextStyle(
                      fontFamily: "poppinsM", fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(
                  height: 15,
                ),
                Image.asset(
                  "assets/images/holiday.png",
                  width: 250,
                  height: 250,
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 5,
                      backgroundColor: const Color(0xFF8B0000),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: const Text(
                    "OK",
                    style: TextStyle(
                        fontFamily: "poppinsM",
                        fontSize: 14,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _selectedCity = BookingFlow.city ?? 'Select City';
    if (BookingFlow.cityData != null) {
      var t = DateTime.parse(
          '${_selectedStartDate.year}-${_selectedStartDate.month < 10 ? '0${_selectedStartDate.month}' : _selectedStartDate.month}-${_selectedStartDate.day < 10 ? '0${_selectedStartDate.day}' : _selectedStartDate.day} ${BookingFlow.cityData!.open_time}');
      var t2 = DateTime.parse(
          '${_selectedStartDate.year}-${_selectedStartDate.month < 10 ? '0${_selectedStartDate.month}' : _selectedStartDate.month}-${_selectedStartDate.day < 10 ? '0${_selectedStartDate.day}' : _selectedStartDate.day} ${BookingFlow.cityData!.close_time}');
      _selectedStartTime =
          _selectedStartTime.isBefore(t) ? t : _selectedStartTime;
      _selectedStartTime =
          _selectedStartTime.isAfter(t2) ? t2 : _selectedStartTime;
    }

    final scaleFactor = MediaQuery.of(context).textScaleFactor;
    bool isLoading = ref.watch(rentalControllerProvider);

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[50],
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              "Search",
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24 / scaleFactor),
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
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "City",
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                            fontSize: 18 / scaleFactor),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => const SelectCitySubs()));
                      },
                      child: Card(
                        elevation: 5,
                        margin: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          side:
                              const BorderSide(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedCity!,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20 / scaleFactor),
                              ),
                              const Icon(Icons.arrow_drop_down)
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Store operational between ',
                            style: TextStyle(fontSize: 14 / scaleFactor)),
                        Text(
                          '${cityData.open_time}',
                          style: TextStyle(
                              fontSize: 14 / scaleFactor,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(139, 0, 0, 1)),
                        ),
                        Text(' to ',
                            style: TextStyle(fontSize: 14 / scaleFactor)),
                        Text('${cityData.close_time}',
                            style: TextStyle(
                                fontSize: 14 / scaleFactor,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(139, 0, 0, 1))),
                      ],
                    )),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Start Date",
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                                fontSize: 18 / scaleFactor),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Subscription",
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                                fontSize: 18 / scaleFactor),
                          ),
                        ),
                      ],
                    ),
                    Card(
                        elevation: 5,
                        margin: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          side:
                              const BorderSide(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _selectStartDate(context);
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                                "${_selectedStartDate.day} ${months[((_selectedStartDate.month) - 1)]}",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize:
                                                        18 / scaleFactor)),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                                DateFormat('hh:mm a')
                                                    .format(_selectedStartTime),
                                                style: TextStyle(
                                                    color: Colors.grey[700],
                                                    fontSize: 18 / scaleFactor))
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                                weeks[
                                                    _selectedStartDate.weekday -
                                                        1],
                                                style: TextStyle(
                                                    color: Colors.grey[700],
                                                    fontSize:
                                                        20 / scaleFactor)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // _selectEndDate(context);
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        DropdownButton<String>(
                                          elevation: 5,
                                          alignment: Alignment.center,
                                          hint: Text("Select months",
                                              style: TextStyle(
                                                  fontSize: 14 / scaleFactor)),
                                          value: dropdownValue,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              dropdownValue = newValue!;
                                            });
                                          },
                                          items: <String>[
                                            '1',
                                            '2',
                                            '3',
                                            '6',
                                            '12'
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value,
                                                  style: TextStyle(
                                                      fontSize:
                                                          14 / scaleFactor)),
                                            );
                                          }).toList(),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        var formatterDate = DateFormat('yyyy-MM-dd');
                        var formatterTime = DateFormat('HH:mm:ss');
                        BookingFlow.pickup_date =
                            formatterDate.format(_selectedStartDate);
                        bool pickCheck = false;
                        String title = "";
                        String description = "";
                        final pickcheckResponse = await ref
                            .read(rentalControllerProvider.notifier)
                            .checkBlockDate(BookingFlow.pickup_date!, context);
                        if (kDebugMode) {
                          print(pickcheckResponse);
                        }
                        if (pickcheckResponse.isEmpty) {
                          pickCheck = true;
                        } else if (pickcheckResponse.isNotEmpty) {
                          title = pickcheckResponse[0];
                          description = pickcheckResponse[1];
                        }
                        BookingFlow.pickup_date =
                            ("${BookingFlow.pickup_date!} ${formatterTime.format(_selectedStartTime)}");
                        BookingFlow.duration = dropdownValue.toString();
                        if (pickCheck) {
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SubProduct(false)));
                        } else {
                          // ignore: use_build_context_synchronously
                          _showImageSourceDialog(context, title, description);
                        }
                      },
                      child: Card(
                        elevation: 5,
                        margin: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color.fromRGBO(139, 0, 0, 1),
                                    Colors.red[200]!
                                  ])),
                          child: Padding(
                            padding: const EdgeInsets.all(17),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                isLoading
                                    ? const SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(
                                            color: Colors.white),
                                      )
                                    : Text(
                                        "Search",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20 / scaleFactor),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectStartDate(BuildContext context) async {
    showCupertinoModalPopup(
        context: context,
        builder: (builder) => CupertinoActionSheet(
              actions: [
                SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    dateOrder: DatePickerDateOrder.dmy,
                    minimumDate: DateTime.now().add(const Duration(days: -1)),
                    initialDateTime: _selectedStartDate,
                    onDateTimeChanged: (dateTime) {
                      _selectedStartDate = dateTime;
                      setState(() {});
                    },
                  ),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  _selectStartTime(context);
                },
                child: const Text("Done"),
              ),
            ));
  }

  Future<void> _selectStartTime(BuildContext context) async {
    showCupertinoModalPopup(
        context: context,
        builder: (builder) => CupertinoActionSheet(
              actions: [
                SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: _selectedStartTime,
                    minimumDate: DateTime.now().add(const Duration(days: -1)),
                    onDateTimeChanged: (dateTime) {
                      _selectedStartTime = dateTime;
                      setState(() {});
                    },
                  ),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  // _selectEndDate(context);
                },
                child: const Text("Done"),
              ),
            ));
  }

  // ignore: unused_element
  Future<void> _selectEndDate(BuildContext context) async {
    showCupertinoModalPopup(
        context: context,
        builder: (builder) => CupertinoActionSheet(
              actions: [
                SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    dateOrder: DatePickerDateOrder.dmy,
                    initialDateTime: _selectedEndDate,
                    onDateTimeChanged: (dateTime) {
                      _selectedEndDate = dateTime;
                      setState(() {});
                    },
                  ),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  _selectEndTime(context);
                },
                child: const Text("Done"),
              ),
            ));
  }

  Future<void> _selectEndTime(BuildContext context) async {
    showCupertinoModalPopup(
        context: context,
        builder: (builder) => CupertinoActionSheet(
              actions: [
                SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: _selectedEndTime,
                    onDateTimeChanged: (dateTime) {
                      _selectedEndTime = dateTime;
                      setState(() {});
                    },
                  ),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Done"),
              ),
            ));
  }
}
