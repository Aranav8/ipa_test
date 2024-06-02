import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridobiko/controllers/auth/auth_controller.dart';
import 'package:ridobiko/data/BookingData.dart';
import 'package:ridobiko/repositories/bookings/booking_repository.dart';
import 'package:ridobiko/screens/rental/MyHomePage.dart';
import 'package:ridobiko/utils/snackbar.dart';

final bookingControllerProvider =
    StateNotifierProvider<BookingController, bool>((ref) {
  return BookingController(
      bookingRepository: ref.watch(bookingRepositoryProvider), ref: ref);
});

class BookingController extends StateNotifier<bool> {
  final BookingRepository _bookingRepository;
  final Ref _ref;
  BookingController(
      {required BookingRepository bookingRepository, required Ref ref})
      : _bookingRepository = bookingRepository,
        _ref = ref,
        super(false);

  Future<List<List<BookingData>>> getData(BuildContext context) async {
    List<BookingData> onGoing = [];
    List<BookingData> completed = [];

    String token = _ref.read(userProvider)!.token!;
    final response = await _bookingRepository.getData(token);
    response.fold((l) {
      Toast(context, l.message);
    }, (r) {
      for (var data in r['data']['live_bookings']) {
        onGoing.add(BookingData.fromJson(data));
      }
      for (var data in r['data']['previous_bookings']) {
        completed.add(BookingData.fromJson(data));
      }
    });

    return [onGoing, completed];
  }

  setSelfPickup(BuildContext context, BookingData data, int count) async {
    String token = _ref.read(userProvider)!.token!;
    state = true;
    final response = await _bookingRepository.setSelfPickup(token, data, count);
    state = false;

    response.fold((l) {
      Toast(context, l.message);
    }, (r) {
      Toast(context, r);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => const MyHomePage()),
          (route) => false);
    });
  }

  calculateCharges(BuildContext context, BookingData data, String km) async {
    String token = _ref.read(userProvider)!.token!;
    state = true;
    final response = await _bookingRepository.calculateCharges(token, data, km);
    state = false;

    response.fold((l) {
      Toast(context, l.message);
    }, (r) {
      Toast(context, r);
    });
  }
}
