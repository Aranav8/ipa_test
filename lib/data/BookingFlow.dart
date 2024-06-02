import 'package:ridobiko/data/city_data.dart';
import 'package:ridobiko/data/subs_data.dart';

import 'BookingData.dart';

class BookingFlow {
  static String? city;
  static bool fromMore = false;
  static String? pickup_date;
  static String? drop_date = "";
  static List<BikeData>? available_bikes;
  static String? duration;
  static BikeData? selectedBike;
  static BookingData? selectedBooking;

  static SubsData? selectedBikeSubs;

  static Set<String> areas = {};
  static Set<String> brands = {};
  static Set<String> selectedAreas = {};
  static Set<String> selectedBrands = {};

  static String? price;

  static List<SubsData>? available_bikes_subs;

  static CityData? cityData;
}

class BikeData {
  String? vendorEmailId;
  String? bikeId;
  String? bikeBrand;
  String? bikeName;
  String? bikeImage;
  String? actualRent;
  String? rentPerDay;
  String? rentPerHour;
  String? status;
  String? pickup;
  String? drop;
  String? start;
  String? end;
  String? deposit;
  String? kmLimit;
  String? speedLimit;
  String? locality;
  String? homeDelivery;
  String? helmetAdditional;
  String? helmetCharge;
  String? available;
  String? extraKM;

  BikeData(
      {this.vendorEmailId,
      this.bikeId,
      this.bikeBrand,
      this.bikeName,
      this.bikeImage,
      this.actualRent,
      this.rentPerDay,
      this.rentPerHour,
      this.status,
      this.pickup,
      this.drop,
      this.start,
      this.end,
      this.deposit,
      this.kmLimit,
      this.speedLimit,
      this.locality,
      this.homeDelivery,
      this.helmetAdditional,
      this.helmetCharge,
      this.available,
      this.extraKM});

  factory BikeData.fromJson(Map<String, dynamic> json) {
    return BikeData(
        vendorEmailId: json['vendor_email_id'] ?? '',
        bikeId: json['bike_id'] ?? '',
        bikeBrand: json['bike_brand'] ?? '',
        bikeName: json['bike_name'] ?? '',
        bikeImage: json['bike_image'] ?? '',
        actualRent: json['actual_rent'],
        rentPerDay: json['rent_per_day'],
        rentPerHour: json['rent_per_hour'],
        status: json['status'],
        pickup: json['pickup'],
        drop: json['drop'],
        start: json['start'],
        end: json['end'],
        deposit: json['deposit'],
        kmLimit: json['km_limit'],
        speedLimit: json['speed_limit'],
        locality: json['locality'],
        homeDelivery: json['home_delivery'],
        helmetAdditional: json['helmet_additional'],
        helmetCharge: json['helmet_charge'],
        available: json['available'],
        extraKM: json['extra_km_cost']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vendor_email_id'] = this.vendorEmailId;
    data['bike_id'] = this.bikeId;
    data['bike_brand'] = this.bikeBrand;
    data['bike_name'] = this.bikeName;
    data['bike_image'] = this.bikeImage;
    data['actual_rent'] = this.actualRent;
    data['rent_per_day'] = this.rentPerDay;
    data['rent_per_hour'] = this.rentPerHour;
    data['status'] = this.status;
    data['pickup'] = this.pickup;
    data['drop'] = this.drop;
    data['start'] = this.start;
    data['end'] = this.end;
    data['deposit'] = this.deposit;
    data['km_limit'] = this.kmLimit;
    data['speed_limit'] = this.speedLimit;
    data['locality'] = this.locality;
    data['home_delivery'] = this.homeDelivery;
    data['helmet_additional'] = this.helmetAdditional;
    data['helmet_charge'] = this.helmetCharge;
    data['available'] = this.available;
    data['extra_km_cost'] = this.extraKM;
    return data;
  }
}
