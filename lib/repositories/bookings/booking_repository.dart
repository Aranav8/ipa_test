import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ridobiko/core/Constants.dart';
import 'package:ridobiko/core/failure.dart';
import 'package:http/http.dart' as http;
import 'package:ridobiko/core/type_defs.dart';
import 'package:ridobiko/data/BookingData.dart';
import 'package:ridobiko/data/self_drop_data.dart';
import 'package:ridobiko/data/self_pickup_data.dart';

final bookingRepositoryProvider = Provider((ref) {
  return BookingRepository();
});

class BookingRepository {
  FutureEither<dynamic> getData(String token) async {
    try {
      var call = await http.post(
          Uri.parse(
              '${Constants().url}android_app_customer/api/getBookings.php'),
          headers: {
            'token': token,
          });
      var response = jsonDecode(call.body);
      if (kDebugMode) {
        print(call.body);
      }
      if (response['success']) {
        return right(response);
      } else {
        return Left(Failure("There was some error"));
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  FutureEither<String> setSelfPickup(
      String token, BookingData data, int count) async {
    try {
      var headers = {'token': token};
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              '${Constants().url}android_app_customer/api/setSelfPickup.php'));

      request.fields.addAll({
        'order_id': data.transId!,
        'no_of_helmets': count.toString(),
        'KM_meter_pickup': SelfPickupData.kmAtPickup!,
        'destination': data.tripDetails!.destination!,
        'purpose': data.tripDetails!.purpose!,
        'id_collected': data.tripDetails!.idCollected!,
        'fuel_meter_reading': SelfPickupData.kmAtPickup!,
      });
      request.files.add(await http.MultipartFile.fromPath('bike_left',
          SelfPickupData.left == null ? "" : SelfPickupData.left!.path));
      request.files.add(await http.MultipartFile.fromPath('bike_right',
          SelfPickupData.right == null ? "" : SelfPickupData.right!.path));
      request.files.add(await http.MultipartFile.fromPath('bike_front',
          SelfPickupData.front == null ? "" : SelfPickupData.front!.path));
      request.files.add(await http.MultipartFile.fromPath('bike_back',
          SelfPickupData.back == null ? "" : SelfPickupData.back!.path));
      request.files.add(await http.MultipartFile.fromPath(
          'bike_with_customer',
          SelfPickupData.withCustomer == null
              ? ""
              : SelfPickupData.withCustomer!.path));
      request.files.add(await http.MultipartFile.fromPath(
          'bike_fuel_meter',
          SelfPickupData.fuelMeter == null
              ? ""
              : SelfPickupData.fuelMeter!.path));
      request.files.add(await http.MultipartFile.fromPath(
          'helmet_front_1',
          SelfPickupData.pickhelmentfront == null
              ? ""
              : SelfPickupData.pickhelmentfront!.path));
      request.files.add(await http.MultipartFile.fromPath(
          'helmet_back_1',
          SelfPickupData.pickhelmentback == null
              ? ""
              : SelfPickupData.pickhelmentback!.path));
      if (count == 2) {
        request.files.add(await http.MultipartFile.fromPath(
            'helmet_front_2',
            SelfPickupData.pickhelmentleft == null
                ? ""
                : SelfPickupData.pickhelmentleft!.path));
        request.files.add(await http.MultipartFile.fromPath(
            'helmet_back_2',
            SelfPickupData.pickhelmentright == null
                ? ""
                : SelfPickupData.pickhelmentright!.path));
      }
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var res = jsonDecode(await response.stream.bytesToString());
        if (res['success']) {
          return right(res['message']);
        } else {
          return Left(Failure("There was some error"));
        }
      } else {
        return Left(Failure("There was some error"));
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  FutureEither<String> calculateCharges(
      String token, BookingData data, String kmReading) async {
    try {
      var call = await http.post(
          Uri.parse(
              '${Constants().url}android_app_customer/api/getKmCharges.php'),
          headers: {
            'token': token,
          },
          body: {
            "email": data.vendorEmailId,
            "order_id": data.transId,
            "bike_id": data.bikesId,
            "pickup_date": data.pickupDate,
            "drop_date": data.dropDate,
            "km_pickup": data.tripDetails?.kMMeterPickup,
            "km_drop": kmReading,
          });
      var res = jsonDecode(call.body);
      if (res['success']) {
        SelfDropData.extraKmCharge = res['data']['extra_km_charge'];
        SelfDropData.kmAtDrop = kmReading;
        return right(SelfDropData.extraKmCharge!);
      } else {
        return Left(Failure("There was some error"));
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
