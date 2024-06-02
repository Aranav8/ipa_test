import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ridobiko/data/coupon.dart';
import 'package:ridobiko/screens/more/LicenseUpload.dart';
import 'package:ridobiko/controllers/auth/auth_controller.dart';
import 'package:ridobiko/data/BookingFlow.dart';
import 'package:ridobiko/data/documents.dart';
import 'package:ridobiko/data/raise_issue_data.dart';
import 'package:ridobiko/data/user_model.dart';
import 'package:ridobiko/repositories/auth/auth_repository.dart';
import 'package:ridobiko/repositories/more/more_repository.dart';
import 'package:ridobiko/screens/more/NewSecurityDeposit.dart';
import 'package:ridobiko/utils/snackbar.dart';

final moreControllerProvider =
    StateNotifierProvider<MoreController, bool>((ref) {
  return MoreController(
      moreRepository: ref.watch(moreRepositoryProvider), ref: ref);
});

class MoreController extends StateNotifier<bool> {
  final MoreRepository _moreRepository;
  final Ref _ref;

  MoreController({required MoreRepository moreRepository, required Ref ref})
      : _moreRepository = moreRepository,
        _ref = ref,
        super(false);

  Future<bool> raiseIssue(
      String issue, String comment, BuildContext context) async {
    state = true;
    String token = _ref.read(userProvider)!.token!;
    bool ans = false;
    final response = await _moreRepository.raiseIssue(token, issue, comment);
    state = false;
    response.fold((l) {
      Toast(context, l.message);
    }, (r) {
      ans = r;
    });

    return ans;
  }

  Future<List<RaiseIssueData>> getDataFromAPI(BuildContext context) async {
    String token = _ref.read(userProvider)!.token!;
    List<RaiseIssueData> issue = [];
    final response = await _moreRepository.getDataFromAPI(token);
    response.fold((l) {
      Toast(context, l.message);
    }, (r) {
      issue = r;
    });

    return issue;
  }

  Future<bool> setUserDetails(
      UserModel user, XFile? profileImage, BuildContext context) async {
    bool ans = false;

    final response = await _moreRepository.setUserDetails(user, profileImage);
    response.fold((l) {
      Toast(context, l.message);
    }, (r) {
      _ref.read(authRepositoryProvider).saveUserData(user);

      ans = r;
    });

    if (profileImage != null) {
      _ref.read(authControllerProvider.notifier).getUserDetails();
    }

    return ans;
  }

  Future<bool> sendOTPEmail(
      String email, String otp, BuildContext context) async {
    String token = _ref.read(userProvider)!.token!;
    bool ans = false;
    final response = await _moreRepository.senOTPEmail(token, email, otp);
    response.fold((l) {
      Toast(context, l.message);
    }, (r) {
      ans = r;
    });

    return ans;
  }

  Future<bool> checkTrips(BuildContext context) async {
    String token = _ref.read(userProvider)!.token!;
    bool ans = false;
    final response = await _moreRepository.checkTrips(token);
    response.fold((l) {
      Toast(context, l.message);
    }, (r) {
      ans = r;
    });

    return ans;
  }

  Future<bool> sendOTPPhone(
      String mobile, String otp, BuildContext context) async {
    String token = _ref.read(userProvider)!.token!;
    bool ans = false;
    final response = await _moreRepository.senOTPPhone(token, mobile, otp);
    response.fold((l) {
      Toast(context, l.message);
    }, (r) {
      ans = r;
    });

    return ans;
  }

  Future<List<List<String>>> checkUserExists(BuildContext context) async {
    String mobile = _ref.read(userProvider)!.mobile!;
    List<String> name = [];
    List<String> mobileNumbers = [];
    final response = await _moreRepository.checkUserExists(mobile);
    response.fold((l) {
      Toast(context, l.message);
    }, (r) {
      for (dynamic each in r['data']['refferal_team']) {
        name.add(each['name']);
        mobileNumbers.add(each['reffered_to']);
      }
    });

    return [name, mobileNumbers];
  }

  Future<List<CouponModel>> getCoupons(BuildContext context) async {
    String mobile = _ref.read(userProvider)!.mobile!;
    List<CouponModel> coupons = [];
    final response = await _moreRepository.checkUserExists(mobile);
    response.fold((l) {
      Toast(context, l.message);
    }, (r) {
      for (dynamic each in r['data']['coupons']) {
        CouponModel temp = CouponModel(
            coupon: each['coupon_code'],
            couponImage: each['coupon_image'],
            description: each['description'],
            amount: each['amount'] != "" ? double.parse(each['amount']) : 0.0,
            startDate: "",
            endDate: each['valid_till'],
            startPrice: each['start_price'] != ""
                ? double.parse(each['start_price'])
                : 0.0,
            city: each["city"],
            used: each["used"] != "" ? int.parse(each["used"]) : 0,
            maxCount: 1);

        coupons.add(temp);
      }
    });
    return coupons;
  }

  Future<dynamic> addReferral(
      String name, String mobile, BuildContext context) async {
    String token = _ref.read(userProvider)!.token!;
    dynamic ans;
    final response = await _moreRepository.addReferral(token, name, mobile);
    response.fold((l) {
      Toast(context, l.message);
    }, (r) {
      ans = r;
    });

    return ans;
  }

  updateAadhaar(BuildContext context, XFile? front, XFile? back) async {
    String token = _ref.read(userProvider)!.token!;
    state = true;
    final response = await _moreRepository.updateAadhaar(token, front, back);
    state = false;
    response.fold((l) {
      Toast(context, l.message);
    }, (r) {
      Toast(context, r['message']);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LicenseUpload()));
      _ref.read(authControllerProvider.notifier).getUserDetails();
      UserModel temp = _ref.read(userProvider)!;

      Documents.selfie = temp.profileImage!;

      Documents.adhaar_front = temp.aadhaarFront!;
      Documents.adhaar_back = temp.aadhaarBack!;
      Documents.dl = temp.drivingLicense!;
      Documents.aadhar_verfied = temp.aadhaarVerified2!;
      Documents.dl_verfied = temp.dlVerified!;
    });
  }

  updateLicence(BuildContext context, XFile? licence) async {
    String token = _ref.read(userProvider)!.token!;
    state = true;
    final response = await _moreRepository.updateLicence(token, licence);
    state = false;
    response.fold((l) {
      Toast(context, l.message);
    }, (r) {
      Toast(context, r['message']);
      _ref.read(authControllerProvider.notifier).getUserDetails();
      UserModel temp = _ref.read(userProvider)!;

      Documents.selfie = temp.profileImage!;

      Documents.adhaar_front = temp.aadhaarFront!;
      Documents.adhaar_back = temp.aadhaarBack!;
      Documents.dl = temp.drivingLicense!;
      Documents.aadhar_verfied = temp.aadhaarVerified2!;
      Documents.dl_verfied = temp.dlVerified!;

      int? securityDeposit = BookingFlow.fromMore == false
          ? BookingFlow.selectedBikeSubs != null
              ? int.parse(BookingFlow.selectedBikeSubs!.deposit!)
              : int.parse(BookingFlow.selectedBike!.deposit!)
          : null;
      BookingFlow.fromMore
          ? Navigator.pop(context)
          : Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (builder) => NewSecurityDepoPB(securityDeposit)));
    });
  }
}
