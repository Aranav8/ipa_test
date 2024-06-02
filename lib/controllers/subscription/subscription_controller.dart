import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridobiko/controllers/auth/auth_controller.dart';
import 'package:ridobiko/data/city_data.dart';
import 'package:ridobiko/repositories/subscription/subscription_repository.dart';
import 'package:ridobiko/utils/snackbar.dart';

final subscriptionControllerProvider =
    StateNotifierProvider<SubscriptionController, bool>((ref) {
  return SubscriptionController(
      subscriptionRepository: ref.watch(subscriptionRepositoryProvider),
      ref: ref);
});

class SubscriptionController extends StateNotifier<bool> {
  final SubscriptionRepository _subscriptionRepository;
  final Ref _ref;

  SubscriptionController(
      {required SubscriptionRepository subscriptionRepository,
      required Ref ref})
      : _subscriptionRepository = subscriptionRepository,
        _ref = ref,
        super(false);

  Future<List<CityData>> fetchCities(BuildContext context) async {
    List<CityData> cities = [];
    String token = _ref.read(userProvider)!.token!;
    final response = await _subscriptionRepository.fetchCities(token);
    response.fold((l) {
      Toast(context, l.message);
    }, (r) {
      for (var city in r) {
        cities.add(CityData.fromJson(city));
      }
    });
    return cities;
  }

  Future<List<List<dynamic>>> fetchBikes(BuildContext context) async {
    List<List<dynamic>> ans = [];
    String token = _ref.read(userProvider)!.token!;
    final response = await _subscriptionRepository.fetchBikes(token);
    response.fold((l) {
      Toast(context, l.message);
    }, (r) {
      ans.add(r[0]);
      ans.add(r[1]);
    });
    return ans;
  }
}
