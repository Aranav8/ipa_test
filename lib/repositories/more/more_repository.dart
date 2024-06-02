import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ridobiko/core/Constants.dart';
import 'package:ridobiko/core/failure.dart';
import 'package:ridobiko/core/type_defs.dart';
import 'package:ridobiko/data/raise_issue_data.dart';
import 'package:ridobiko/data/user_model.dart';

final moreRepositoryProvider = Provider((ref) {
  return MoreRepository();
});

class MoreRepository {
  FutureEither<bool> raiseIssue(
      String token, String issue, String comment) async {
    try {
      var call = await http.post(
          Uri.parse(
              '${Constants().url}android_app_customer/api/setRaiseTicket.php'),
          body: {
            'issue_type': issue,
            'comment': comment,
          },
          headers: {
            'token': token,
          });
      var response = jsonDecode(call.body);
      if (kDebugMode) {
        print(response);
      }
      if (response['success']) {
        return right(true);
      } else {
        return right(false);
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<List<RaiseIssueData>> getDataFromAPI(String token) async {
    List<RaiseIssueData> issues = [];
    try {
      var call = await http.post(
          Uri.parse(
              '${Constants().url}android_app_customer/api/getRaiseTicket.php'),
          headers: {
            'token': token,
          });
      var response = jsonDecode(call.body);

      if (kDebugMode) {
        print(response);
      }

      if (response['success']) {
        for (var data in response['data']) {
          issues.add(RaiseIssueData.fromJson(data));
        }
      }
      return right(issues);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<bool> senOTPEmail(String token, String email, String otp) async {
    try {
      var call = await http.post(
          Uri.parse(
              'https://www.ridobiko.com/android_app_customer/api/sendEmailOTP.php'),
          headers: {
            'token': token,
          },
          body: {
            'email_otp': otp,
            'email': email,
          });
      var response = jsonDecode(call.body);

      if (kDebugMode) {
        print(response);
      }

      if (response['success']) {
        return right(true);
      } else {
        return right(false);
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<bool> senOTPPhone(
      String token, String mobile, String otp) async {
    try {
      var call = await http.post(
          Uri.parse(
              '${Constants().url}android_app_customer/api/sendEmergencyOTP.php'),
          headers: {
            'token': token,
          },
          body: {
            'emergency_otp': otp,
            'emergency_mobile': mobile,
          });
      var response = jsonDecode(call.body);

      if (kDebugMode) {
        print(response);
      }

      if (response['success']) {
        return right(true);
      } else {
        return right(false);
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<bool> checkTrips(String token) async {
    final url =
        '${Constants().url}android_app_customer/api/detailsEditableCheck.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'token': token,
        },
      );
      if (kDebugMode) {
        print(response.body);
      }
      final responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody["success"] == true) {
        if (responseBody["data"]["proceed"] == 1) {
          return right(true);
        } else {
          return right(false);
        }
      } else {
        return left(Failure("There is some error"));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<bool> setUserDetails(UserModel user, XFile? profileImage) async {
    try {
      var headers = {'token': user.token!};
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              '${Constants().url}android_app_customer/api/setUserDetails.php'));
      request.fields.addAll({
        'name': user.firstname!,
        'email': user.email!,
        'emergency_no': user.emergencyMobile!,
        'employer': ' ',
        'profession': ' ',
        'emergency_name': user.emergencyName!,
        'emergency_relation': user.emergencyRelation!,
        'email_verified': user.emailVerified!,
        'emobile_verified': user.emergencyMobileVerified!,
        'current_address_house': user.currentAddressHouse!,
        'current_address_area': user.currentAddressArea!,
        'current_address_landmark': user.currentAddressLandmark!,
        'current_address_city': user.currentAddressCity!,
        'permanent_address_house': user.permanentAddressHouse!,
        'permanent_address_area': user.permanentAddressArea!,
        'permanent_address_landmark': user.permanentAddressLandmark!,
        'permanent_address_city': user.permanentAddressCity!,
      });
      request.headers.addAll(headers);
      if (profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'image_profile', profileImage.path));
      }
      http.StreamedResponse call = await request.send();

      var json = jsonDecode(await call.stream.bytesToString());

      if (kDebugMode) {
        print(json);
      }

      if (call.statusCode == 200) {
        return right(true);
      } else {
        return right(false);
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<dynamic> updateAadhaar(
      String token, XFile? front, XFile? back) async {
    try {
      var headers = {'token': token};
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              '${Constants().url}android_app_customer/api/updateAdhaarData.php'));
      request.files
          .add(await http.MultipartFile.fromPath('adhaar_front', front!.path));
      request.files
          .add(await http.MultipartFile.fromPath('adhaar_back', back!.path));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var json = jsonDecode(await response.stream.bytesToString());
        return right(json);
      } else {
        return left(Failure("Some error occured try again"));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<dynamic> updateLicence(String token, XFile? licence) async {
    try {
      var headers = {'token': token};
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              '${Constants().url}android_app_customer/api/updateDrivingLicenseData.php'));
      request.files.add(
          await http.MultipartFile.fromPath('driving_license', licence!.path));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var json = jsonDecode(await response.stream.bytesToString());
        return right(json);
      } else {
        return left(Failure("Some error occured try again"));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<dynamic> checkUserExists(String mobile) async {
    try {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              '${Constants().url}android_app_customer/api/checkExistingUser.php'));
      request.fields.addAll({'mobile': mobile});

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var json = jsonDecode(await response.stream.bytesToString());
        if (kDebugMode) {
          print(json);
        }
        return right(json);
      } else {
        return left(Failure("Some error occured try again"));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<dynamic> addReferral(
      String token, String name, String mobile) async {
    try {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              '${Constants().url}android_app_customer/api/addRefferalMember.php'));
      request.fields.addAll({'member_name': name, "member_mobile": mobile});
      request.headers.addAll({'token': token});
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var json = jsonDecode(await response.stream.bytesToString());
        return right(json);
      } else {
        return left(Failure("Some error occured try again"));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
