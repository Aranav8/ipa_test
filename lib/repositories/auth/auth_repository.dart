import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:ridobiko/core/Constants.dart';
import 'package:ridobiko/core/failure.dart';
import 'package:ridobiko/core/type_defs.dart';
import 'package:ridobiko/data/user_model.dart';
import 'package:ridobiko/utils/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(prefs: SharedPreferencesService.preferences);
});

class AuthRepository {
  final SharedPreferences _pref;

  AuthRepository({required SharedPreferences prefs}) : _pref = prefs;
  static const String _userDataKey = 'user_data';

  Future<void> saveUserData(UserModel? user) async {
    await _pref.setString(_userDataKey, user != null ? user.toJson() : "");
  }

  Future<UserModel?> getUserData() async {
    String? user = _pref.getString(_userDataKey);
    if (user != null && user != "") {
      return UserModel.fromJson(user);
    } else {
      return null;
    }
  }

  FutureEither<UserModel?> userLogin(String mobile, String password) async {
    if (kDebugMode) {
      print('${Constants().url}android_app_customer/api/api_login.php');
    }

    try {
      var call = await http.post(
          Uri.parse('${Constants().url}android_app_customer/api/api_login.php'),
          body: {'mobile': mobile, 'pass': password});
      var response = jsonDecode(call.body);
      if (response['status'] == true) {
        UserModel user = UserModel.fromJson2(response['data']['user']);
        user = user.copyWith(token: response['data']['token']);
        saveUserData(user);
        return right(user);
      } else {
        return right(null);
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<bool> checkForUpdate() async {
    if (kDebugMode) {
      print('${Constants().url}android_app_customer/api/versionCheck.php');
    }
    final url = '${Constants().url}android_app_customer/api/versionCheck.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {'version': '1.18.11+39'},
      );
      final responseBody = json.decode(response.body);
      if (response.statusCode == 200 &&
          responseBody["message"] == "Outdated App Version") {
        return right(true);
      } else {
        return right(false);
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<bool> sentOtp(String phone, int otp) async {
    try {
      var call = await http.post(
          Uri.parse('${Constants().url}android_app_customer/api/api_otp.php'),
          body: {'mobile': phone, 'otp': otp.toString()});

      var response = jsonDecode(call.body);
      if (response['status'] == true) {
        return right(true);
      } else {
        return right(false);
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<dynamic> checkUser(String phone) async {
    try {
      var call = await http.post(
          Uri.parse(
              '${Constants().url}android_app_customer/api/api_userstate.php'),
          body: {
            'mobile': phone,
          });
      var response = jsonDecode(call.body);

      if (response['status'] == true) {
        if (response['newUser'] == true) {
          return right(null);
        } else {
          return right(response);
        }
      } else {
        return left(Failure("There was some error"));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<dynamic> signupCustomer(
      String name, String phone, String email, String pass) async {
    try {
      var call = await http.post(
          Uri.parse(
              '${Constants().url}android_app_customer/api/api_signup.php'),
          body: {
            'mobile': phone,
            'name': name,
            'email': email,
            'pass': pass,
          });
      var response = jsonDecode(call.body);
      if (response['status'] == true) {
        return right(response);
      } else {
        return left(Failure(response['message']));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<dynamic> resetPassword(String number, String password) async {
    try {
      var call = await http.post(
          Uri.parse(
              '${Constants().url}android_app_customer/api/forgotPassword.php'),
          body: {
            'mobile': number,
            'new_password': password,
          });

      var response = jsonDecode(call.body);

      if (response['status'] == "true") {
        return right(response);
      } else {
        return left(Failure("Failed to change the password"));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<dynamic> getUserDetails(String token) async {
    try {
      var call = await http.post(
          Uri.parse(
              '${Constants().url}android_app_customer/api/getUserDetials.php'),
          headers: {'token': token});
      if (kDebugMode) {
        print(call.body);
      }

      var response = jsonDecode(call.body);
      if (response['success'] == true) {
        return right(response);
      } else {
        return left(Failure("There was some error"));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
