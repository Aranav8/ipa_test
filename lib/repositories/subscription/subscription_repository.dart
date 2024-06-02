import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ridobiko/core/Constants.dart';
import 'package:ridobiko/core/failure.dart';
import 'package:http/http.dart' as http;
import 'package:ridobiko/core/type_defs.dart';
import 'package:ridobiko/data/BookingFlow.dart';
import 'package:ridobiko/data/subs_data.dart';

final subscriptionRepositoryProvider = Provider((ref) {
  return SubscriptionRepository();
});

class SubscriptionRepository {
  FutureEither<dynamic> fetchCities(String token) async {
    try {
      var call = await http.post(
          Uri.parse(
              '${Constants().url}android_app_customer/api/getSubscriptionCities.php'),
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

  FutureEither<List<List<dynamic>>> fetchBikes(String token) async {
    try {
      int count = 0;
      var call = await http.post(
          Uri.parse(
              '${Constants().url}android_app_customer/api/getSubscriptionBikes.php'),
          headers: {
            'token': token,
          },
          body: {
            'city': BookingFlow.city,
            'pickup': BookingFlow.pickup_date,
            'month': BookingFlow.duration,
          });

      var response = jsonDecode(call.body);
      if (kDebugMode) {
        print(response);
      }
      if (response['success'] == true) {
        if (kDebugMode) {
          print(response);
        }
        List<SubsData> list = [];
        for (var data in response['data']) {
          SubsData d = SubsData.fromJson(data);
          list.add(d);
          BookingFlow.areas.add(d.locality!);
          BookingFlow.brands.add(d.bikeBrand!);
          if (d.available == 'yes') count++;
        }
        BookingFlow.available_bikes_subs = list;
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
