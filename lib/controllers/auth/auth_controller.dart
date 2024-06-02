import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ridobiko/screens/rental/MyHomePage.dart';
import 'package:ridobiko/core/type_defs.dart';
import 'package:ridobiko/data/user_model.dart';
import 'package:ridobiko/repositories/auth/auth_repository.dart';
import 'package:ridobiko/screens/auth/SignupCustomer.dart';
import 'package:ridobiko/utils/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
      authRepository: ref.watch(authRepositoryProvider), ref: ref);
});

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

  Future<void> userLogin(
      String mobile, String password, BuildContext context) async {
    state = true;
    final Either<Failure, UserModel?> loginSuccess;
    loginSuccess = await _authRepository.userLogin(mobile, password);
    state = false;

    loginSuccess.fold((l) {
      Toast(context, l.message);
    }, (user) async {
      if (user != null) {
        _ref.read(userProvider.notifier).update((state) => user);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', user.token ?? '');
        await prefs.setString('mobile', mobile);
        if (kDebugMode) {
          print('Mobile number saved: $mobile');
        }
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MyHomePage()),
          (route) => false,
        );
        await checkTokenStored();
      } else {
        Toast(context, "Incorrect Number or Password");
      }
    });
  }

  Future<void> checkTokenStored() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      if (kDebugMode) {
        print('Token is stored: $token');
      }
    } else {
      if (kDebugMode) {
        print('Token is not stored');
      }
    }
  }

  Future<bool> checkForUpdate(BuildContext context) async {
    final result = await _authRepository.checkForUpdate();
    bool response = false;

    result.fold((l) {
      Toast(context, l.message);
    }, (r) {
      response = r;
    });

    return response;
  }

  Future<bool> sentOtp(String phone, int otp, BuildContext context) async {
    state = true;
    final result = await _authRepository.sentOtp(phone, otp);
    state = false;
    bool response = false;
    result.fold((l) {
      Toast(context, l.message);
    }, (r) {
      if (!r) {
        Toast(context, "There was some error in sending OTP");
      } else {
        UserModel user = UserModel(
            mobile: phone,
            firstname: "",
            dlVerified: "",
            lastname: "",
            aadhaarVerified: "",
            email: "",
            token: "");
        _authRepository.saveUserData(user);
        _ref.read(userProvider.notifier).update((state) => user);

        response = true;
      }
    });
    return response;
  }

  Future<void> checkUser(String phone, BuildContext context) async {
    state = true;
    final Either<Failure, dynamic> response =
        await _authRepository.checkUser(phone);
    state = false;

    response.fold(
      (l) {
        Toast(context, l.message);
      },
      (r) async {
        if (r == null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (builder) => const Signup_Customer()),
          );
        } else {
          final responseUser = r['data']['user'];

          final UserModel user = UserModel(
            mobile: responseUser['mobile'],
            firstname: responseUser['firstname'],
            dlVerified: "0",
            lastname: responseUser['lastname'],
            aadhaarVerified: "0",
            email: responseUser['email'],
            token: r['data']['token'],
          );

          _authRepository.saveUserData(user);
          _ref.read(userProvider.notifier).update((state) => user);

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', user.token ?? '');
          await prefs.setString('mobile', phone);

          if (kDebugMode) {
            print('Mobile number saved: $phone');
          }

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MyHomePage()),
            (route) => false,
          );

          await checkTokenStored();
        }
      },
    );
  }

  Future<void> signupCustomer(String name, String phone, String email,
      String pass, BuildContext context) async {
    state = true;
    final Either<Failure, dynamic> response =
        await _authRepository.signupCustomer(name, phone, email, pass);
    state = false;

    response.fold(
      (l) {
        Toast(context, l.message);
      },
      (r) {
        final responseUser = r?['data']['user'];

        final UserModel user = UserModel(
          mobile: responseUser['mobile'],
          firstname: responseUser['firstname'],
          dlVerified: "0",
          lastname: responseUser['lastname'],
          aadhaarVerified: "0",
          email: responseUser['email'],
          token: r?['data']['token'],
        );

        _authRepository.saveUserData(user);
        _ref.read(userProvider.notifier).update((state) => user);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => const MyHomePage()),
          (route) => false,
        );
      },
    );
  }

  resetPassword(String number, String password, BuildContext context) async {
    state = true;
    final response = await _authRepository.resetPassword(number, password);
    state = false;
    response.fold((l) {
      Toast(context, l.message);
    }, (r) {
      var response = r['data']['user'];

      _ref.read(userProvider.notifier).update((state) {
        UserModel user = UserModel(
            mobile: response['mobile'],
            firstname: response['firstname'],
            dlVerified: "0",
            lastname: response['lastname'],
            aadhaarVerified: "0",
            email: response['email'],
            token: r['data']['token']);
        _authRepository.saveUserData(user);
        return user;
      });

      Toast(context, "Password changed successfully");

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => const MyHomePage()),
          (route) => false);
    });
  }

  getUserDetails() async {
    UserModel oldData = _ref.read(userProvider)!;
    UserModel? newData;

    final response = await _authRepository.getUserDetails(oldData.token!);
    response.fold((l) {
      if (kDebugMode) {
        print(l.message);
      }
    }, (r) {
      newData = UserModel.fromJson2(r['data']);
      newData = newData!.copyWith(
          aadhaarVerified: oldData.aadhaarVerified2,
          dlVerified: oldData.drivingLicenseVerified,
          firstname: oldData.firstname,
          token: oldData.token);
    });

    _ref.read(userProvider.notifier).update((state) => newData);
    _authRepository.saveUserData(newData);
  }
}
