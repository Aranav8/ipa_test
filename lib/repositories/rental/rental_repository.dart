import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:ridobiko/core/Constants.dart';
import 'package:ridobiko/core/failure.dart';
import 'package:ridobiko/core/type_defs.dart';
import 'package:ridobiko/data/BookingFlow.dart';

final rentalRepositoryProvider = Provider((ref) {
  return RentalRepository();
});

class RentalRepository {
  FutureEither<dynamic> loadWhatsNewData(String token) async {
    try {
      var call = await http.post(
          Uri.parse(
              '${Constants().url}android_app_customer/api/whatsNewSection.php'),
          headers: {
            'token': token,
          });
      var response = jsonDecode(call.body);
      if (kDebugMode) {
        print(response);
      }
      if (response['success']) {
        return right(response);
      } else {
        return left(Failure(response['message']));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<dynamic> loadBlogsData(String token) async {
    try {
      var call = await http.post(
          Uri.parse('${Constants().url}android_app_customer/api/getBlog.php'),
          headers: {
            'token': token,
          });
      var response = jsonDecode(call.body);
      if (response['success']) {
        return right(response);
      } else {
        return left(Failure(response['message']));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<dynamic> fetchCities(String token) async {
    try {
      var call = await http.post(
          Uri.parse('${Constants().url}android_app_customer/api/getCities.php'),
          headers: {'token': token});
      if (kDebugMode) {
        print(call.body);
      }
      var response = jsonDecode(call.body);
      if (response['success'] == true) {
        var cities = response['data'];
        return right(cities);
      } else {
        return left(Failure(response['message']));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<List<String>> checkBlockDate(String date, String token) async {
    try {
      final url =
          "${Constants().url}android_app_customer/api/checkBolckDates.php";

      final response = await http.post(Uri.parse(url),
          body: {'date': date}, headers: {'token': token});

      if (kDebugMode) {
        print(response.body);
      }

      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 && responseBody['success'] == true) {
        List<String> temp = [];
        temp.add(responseBody['data']['title']);
        temp.add(responseBody['data']['description']);
        return right(temp);
      } else if (response.statusCode == 200 &&
          responseBody['success'] == false) {
        return right([]);
      } else {
        return left(Failure("There was some error"));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<List<List<dynamic>>> fetchBikes(String token) async {
    try {
      int count = 0;
      var call = await http.post(
          Uri.parse(
              '${Constants().url}android_app_customer/api/searchBikes.php'),
          headers: {
            'token': token,
          },
          body: {
            'city': BookingFlow.city,
            'pickup': BookingFlow.pickup_date,
            'drop': BookingFlow.drop_date,
          });

      var response = jsonDecode(call.body);
      if (response['success'] == true) {
        if (kDebugMode) {
          print(response);
        }
        List<BikeData> list = [];
        for (var data in response['data']) {
          BikeData d = BikeData.fromJson(data);
          list.add(d);
          BookingFlow.areas.add(d.locality!);
          BookingFlow.brands.add(d.bikeBrand!);
          if (d.available == 'yes') count++;
        }
        BookingFlow.available_bikes = list;
        return right([
          [count],
          list
        ]);
      } else {
        return left(Failure(response['message']));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
