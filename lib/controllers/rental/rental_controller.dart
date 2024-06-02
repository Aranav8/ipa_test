import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridobiko/controllers/auth/auth_controller.dart';
import 'package:ridobiko/data/blog_data.dart';
import 'package:ridobiko/data/city_data.dart';
import 'package:ridobiko/data/whats_data.dart';
import 'package:ridobiko/repositories/rental/rental_repository.dart';
import 'package:ridobiko/utils/snackbar.dart';

final rentalControllerProvider =
    StateNotifierProvider<RentalController, bool>((ref) {
  return RentalController(
      rentalRepository: ref.watch(rentalRepositoryProvider), ref: ref);
});

class RentalController extends StateNotifier<bool> {
  final RentalRepository _rentalRepository;
  final Ref _ref;
  RentalController(
      {required RentalRepository rentalRepository, required Ref ref})
      : _rentalRepository = rentalRepository,
        _ref = ref,
        super(false);

  Future<List<WhatsData>> loadWhatsNewData(BuildContext context) async {
    List<WhatsData> ans = [];
    if (WhatsDataCache.getCachedData() != null) {
      ans.add(WhatsDataCache.getCachedData()!);
      return ans;
    }
    String token = _ref.read(userProvider)!.token!;
    final response = await _rentalRepository.loadWhatsNewData(token);
    response.fold((l) {
      Toast(context, l.message);
    }, (r) {
      for (var data in r['data']) {
        ans.add(WhatsData.fromJson(data));
        WhatsDataCache.cacheData(ans[0]);
      }
    });
    return ans;
  }

  Future<List<Blog>> loadBlogsData(BuildContext context) async {
    List<Blog> ans = [];
    String token = _ref.read(userProvider)!.token!;
    final response = await _rentalRepository.loadBlogsData(token);
    response.fold((l) {
      Toast(context, l.message);
    }, (r) {
      for (var data in r['data']) {
        ans.add(Blog.fromJson(data));
      }
      ans = ans.reversed.toList();
    });
    return ans;
  }

  Future<List<List<dynamic>>> fetchCities(BuildContext context) async {
    List<CityData> cities = [];
    List<CityData> popularCities = [];
    String token = _ref.read(userProvider)!.token!;
    final response = await _rentalRepository.fetchCities(token);
    response.fold((l) {
      Toast(context, l.message);
    }, (r) {
      for (var popularCity in r['popular_cities']) {
        popularCities.add(CityData.fromJson(popularCity));
      }
      for (var city in r['city']) {
        cities.add(CityData.fromJson(city));
      }
    });
    return [cities, popularCities];
  }

  Future<List<String>> checkBlockDate(String date, BuildContext context) async {
    List<String> ans = [];
    String token = _ref.read(userProvider)!.token!;
    state = true;
    final response = await _rentalRepository.checkBlockDate(date, token);
    state = false;
    response.fold((l) {
      Toast(context, l.message);
    }, (r) {
      ans = r;
    });
    return ans;
  }

  Future<List<List<dynamic>>> fetchBikes(BuildContext context) async {
    List<List<dynamic>> ans = [];
    String token = _ref.read(userProvider)!.token!;
    final response = await _rentalRepository.fetchBikes(token);
    response.fold((l) {
      Toast(context, l.message);
    }, (r) {
      ans.add(r[0]);
      ans.add(r[1]);
    });
    return ans;
  }
}
