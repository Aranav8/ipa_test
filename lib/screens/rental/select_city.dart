import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ridobiko/screens/rental/search.dart';
import 'package:ridobiko/controllers/rental/rental_controller.dart';
import 'package:ridobiko/data/BookingFlow.dart';
import 'package:ridobiko/data/city_data.dart';

class SelectCity extends ConsumerStatefulWidget {
  const SelectCity({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _selectCityPage();
  }
}

// ignore: camel_case_types
class _selectCityPage extends ConsumerState<SelectCity> {
  List<CityData> cities = [];
  List<CityData> popularCities = [];

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
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
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
                      Visibility(
                        visible: popularCities.isNotEmpty && cities.isNotEmpty,
                        child: const SizedBox(
                          height: 20,
                        ),
                      ),
                      Visibility(
                        visible: popularCities.isNotEmpty && cities.isNotEmpty,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Popular Cities",
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                                fontSize: 18 / scaleFactor),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (popularCities.isNotEmpty)
                                _popularCity(popularCities.elementAt(0)),
                              if (popularCities.isNotEmpty)
                                _popularCity(popularCities.elementAt(1)),
                              if (popularCities.isNotEmpty)
                                _popularCity(popularCities.elementAt(2)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (popularCities.isNotEmpty)
                                _popularCity(popularCities.elementAt(3)),
                              if (popularCities.isNotEmpty)
                                _popularCity(popularCities.elementAt(4)),
                              if (popularCities.isNotEmpty)
                                _popularCity(popularCities.elementAt(5)),
                            ],
                          ),
                        ],
                      ),
                      Visibility(
                        visible: popularCities.isNotEmpty && cities.isNotEmpty,
                        child: const SizedBox(
                          height: 20,
                        ),
                      ),
                      Visibility(
                        visible: popularCities.isNotEmpty && cities.isNotEmpty,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Other Cities",
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                                fontSize: 18 / scaleFactor),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 5,
                        margin: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 300,
                            child: ListView.builder(
                              itemBuilder: (builder, i) {
                                return _otherCity(cities.elementAt(i));
                              },
                              itemCount: cities.length,
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
              Center(
                child: Visibility(
                    visible: popularCities.isEmpty && cities.isEmpty,
                    child: Column(
                      children: [
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
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (builder) => const Search()));
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
                        color: selected == name.city_name
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

  Widget _popularCity(CityData name) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          selected = name.city_name!;
          BookingFlow.city = selected;
          BookingFlow.cityData = name;
          setState(() {});
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (builder) => const Search()));
        },
        child: Card(
          elevation: 5,
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(
                  width: 1.5,
                  color: selected == name.city_name
                      ? Colors.red[700]!
                      : Colors.white)),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: SizedBox(
              // width: 80,
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.network(
                    name.city_image!,
                    width: 80,
                    fit: BoxFit.cover,
                    color: selected == name.city_name
                        ? Colors.red[700]
                        : Colors.black,
                  ),
                  Text(
                    name.city_name!,
                    style: TextStyle(
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w500,
                        color: selected == name.city_name
                            ? Colors.red[700]
                            : Colors.black),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _fetchCities() async {
    List<List<dynamic>> response =
        await ref.read(rentalControllerProvider.notifier).fetchCities(context);
    cities = response[0].cast<CityData>();
    popularCities = response[1].cast<CityData>();
    setState(() {});

    // try {
    //   String token = ref.read(userProvider)!.token;
    //   print(token);
    //   var call = await http.post(
    //       Uri.parse(
    //           'https://www.ridobiko.com/android_app_customer/api/getCities.php'),
    //       headers: {'token': token});
    //   var response = jsonDecode(call.body);
    //   if (response['success'] == true) {
    //     var cities = response['data'];
    //     for (var popularCity in cities['popular_cities']) {
    //       _popularCities.add(CityData.fromJson(popularCity));
    //     }
    //     for (var city in cities['city']) {
    //       _cities.add(CityData.fromJson(city));
    //     }
    //     setState(() {});
    //   } else {
    //     ScaffoldMessenger.of(context)
    //         .showSnackBar(SnackBar(content: Text(response['message'])));
    //   }
    // } catch (e) {
    //   print(e);
    // }
  }
}
