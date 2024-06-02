import 'dart:convert';

class UserModel {
  final String? mobile;
  final String? firstname;
  final String? lastname;
  final String? email;
  final String? aadhaarVerified;
  final String? dlVerified;
  final String? token;

  final String? emergencyMobile;
  final String? emergencyName;
  final String? emergencyRelation;
  final String? emergencyMobileVerified;
  final String? currentAddressHouse;
  final String? currentAddressArea;
  final String? currentAddressLandmark;
  final String? currentAddressCity;
  final String? permanentAddressHouse;
  final String? permanentAddressArea;
  final String? permanentAddressLandmark;
  final String? permanentAddressCity;
  final String? aadhaarNumber;
  final String? aadhaarFront;
  final String? aadhaarBack;
  final String? aadhaarVerified2;
  final String? dlNumber;
  final String? drivingLicense;
  final String? drivingLicenseVerified;
  final String? profileImage;
  final String? emailVerified;

  UserModel(
      {this.mobile,
      this.firstname,
      this.dlVerified,
      this.lastname,
      this.aadhaarVerified,
      this.email,
      this.token,
      this.emergencyMobile,
      this.emergencyName,
      this.emergencyRelation,
      this.emergencyMobileVerified,
      this.currentAddressHouse,
      this.currentAddressArea,
      this.currentAddressLandmark,
      this.currentAddressCity,
      this.permanentAddressHouse,
      this.permanentAddressArea,
      this.permanentAddressLandmark,
      this.permanentAddressCity,
      this.aadhaarNumber,
      this.aadhaarFront,
      this.aadhaarBack,
      this.aadhaarVerified2,
      this.dlNumber,
      this.drivingLicense,
      this.drivingLicenseVerified,
      this.emailVerified,
      this.profileImage});

  UserModel copyWith(
      {String? mobile,
      String? firstname,
      String? lastname,
      String? email,
      String? aadhaarVerified,
      String? dlVerified,
      String? token,
      String? emergencyMobile,
      String? emergencyName,
      String? emergencyRelation,
      String? emergencyMobileVerified,
      String? currentAddressHouse,
      String? currentAddressArea,
      String? currentAddressLandmark,
      String? currentAddressCity,
      String? permanentAddressHouse,
      String? permanentAddressArea,
      String? permanentAddressLandmark,
      String? permanentAddressCity,
      String? aadhaarNumber,
      String? aadhaarFront,
      String? aadhaarBack,
      String? aadhaarVerified2,
      String? dlNumber,
      String? drivingLicense,
      String? drivingLicenseVerified,
      String? emailVerified,
      String? profileImage}) {
    return UserModel(
        mobile: mobile ?? this.mobile,
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        email: email ?? this.email,
        aadhaarVerified: aadhaarVerified ?? this.aadhaarVerified,
        dlVerified: dlVerified ?? this.dlVerified,
        token: token ?? this.token,
        emergencyMobile: emergencyMobile ?? this.emergencyMobile,
        emergencyName: emergencyName ?? this.emergencyName,
        emergencyRelation: emergencyRelation ?? this.emergencyRelation,
        emergencyMobileVerified:
            emergencyMobileVerified ?? this.emergencyMobileVerified,
        currentAddressHouse: currentAddressHouse ?? this.currentAddressHouse,
        currentAddressArea: currentAddressArea ?? this.currentAddressArea,
        currentAddressLandmark:
            currentAddressLandmark ?? this.currentAddressLandmark,
        currentAddressCity: currentAddressCity ?? this.currentAddressCity,
        permanentAddressHouse:
            permanentAddressHouse ?? this.permanentAddressHouse,
        permanentAddressArea: permanentAddressArea ?? this.permanentAddressArea,
        permanentAddressLandmark:
            permanentAddressLandmark ?? this.permanentAddressLandmark,
        permanentAddressCity: permanentAddressCity ?? this.permanentAddressCity,
        aadhaarNumber: aadhaarNumber ?? this.aadhaarNumber,
        aadhaarFront: aadhaarFront ?? this.aadhaarFront,
        aadhaarBack: aadhaarBack ?? this.aadhaarBack,
        aadhaarVerified2: aadhaarVerified2 ?? this.aadhaarVerified2,
        dlNumber: dlNumber ?? this.dlNumber,
        drivingLicense: drivingLicense ?? this.drivingLicense,
        drivingLicenseVerified:
            drivingLicenseVerified ?? this.drivingLicenseVerified,
        emailVerified: emailVerified ?? this.emailVerified,
        profileImage: profileImage ?? this.profileImage);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mobile': mobile,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'aadhar_verified': aadhaarVerified,
      'driving_license_verified': dlVerified,
      'token': token,
      // Additional parameters
      'emergency_mobile': emergencyMobile,
      'emergency_name': emergencyName,
      'emergency_relation': emergencyRelation,
      'emergency_mobile_verified': emergencyMobileVerified,
      'current_address_house': currentAddressHouse,
      'current_address_area': currentAddressArea,
      'current_address_landmark': currentAddressLandmark,
      'current_address_city': currentAddressCity,
      'permanent_address_house': permanentAddressHouse,
      'permanent_address_area': permanentAddressArea,
      'permanent_address_landmark': permanentAddressLandmark,
      'permanent_address_city': permanentAddressCity,
      'aadhaar_number': aadhaarNumber,
      'aadhaar_front': aadhaarFront,
      'aadhaar_back': aadhaarBack,
      'aadhaar_verified': aadhaarVerified2,
      'dl_number': dlNumber,
      'driving_license': drivingLicense,
      // ignore: equal_keys_in_map
      'driving_license_verified': drivingLicenseVerified,
      'profile_image': profileImage,
      'email_verified': emailVerified
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        mobile: map['mobile'] as String,
        firstname: map['firstname'] as String,
        lastname: map['lastname'] as String,
        email: map['email'] as String,
        aadhaarVerified: map['aadhar_verified'] as String,
        dlVerified: map['driving_license_verified'] as String,
        token: map['token'] as String,
        // Additional parameters
        emergencyMobile: map['emergency_mobile'] as String?,
        emergencyName: map['emergency_name'] as String?,
        emergencyRelation: map['emergency_relation'] as String?,
        emergencyMobileVerified: map['emergency_mobile_verified'] as String?,
        currentAddressHouse: map['current_address_house'] as String?,
        currentAddressArea: map['current_address_area'] as String?,
        currentAddressLandmark: map['current_address_landmark'] as String?,
        currentAddressCity: map['current_address_city'] as String?,
        permanentAddressHouse: map['permanent_address_house'] as String?,
        permanentAddressArea: map['permanent_address_area'] as String?,
        permanentAddressLandmark: map['permanent_address_landmark'] as String?,
        permanentAddressCity: map['permanent_address_city'] as String?,
        aadhaarNumber: map['aadhaar_number'] as String?,
        aadhaarFront: map['aadhaar_front'] as String?,
        aadhaarBack: map['aadhaar_back'] as String?,
        aadhaarVerified2: map['aadhaar_verified'] as String?,
        dlNumber: map['dl_number'] as String?,
        drivingLicense: map['driving_license'] as String?,
        drivingLicenseVerified: map['driving_license_verified'] as String?,
        profileImage: map['profile_image'] as String?,
        emailVerified: map['email_verified'] as String?);
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory UserModel.fromJson2(Map<String, dynamic> json) {
    return UserModel(
        mobile: json['mobile'] ?? '',
        firstname: json['firstname'] ?? '',
        lastname: json['lastname'] ?? '',
        email: json['email'] ?? '',
        aadhaarVerified: json['aadhar_verified'] ?? '',
        dlVerified: json['driving_license_verified'] ?? '',
        token: json['token'] ?? '',
        // Additional parameters
        emergencyMobile: json['emergency_mobile'] ?? '',
        emergencyName: json['emergency_name'] ?? '',
        emergencyRelation: json['emergency_relation'] ?? '',
        emergencyMobileVerified: json['emergency_mobile_verified'] ?? '',
        currentAddressHouse: json['current_address_house'] ?? '',
        currentAddressArea: json['current_address_area'] ?? '',
        currentAddressLandmark: json['current_address_landmark'] ?? '',
        currentAddressCity: json['current_address_city'] ?? '',
        permanentAddressHouse: json['permanent_address_house'] ?? '',
        permanentAddressArea: json['permanent_address_area'] ?? '',
        permanentAddressLandmark: json['permanent_address_landmark'] ?? '',
        permanentAddressCity: json['permanent_address_city'] ?? '',
        aadhaarNumber: json['aadhaar_number'] ?? '',
        aadhaarFront: json['aadhaar_front'] ?? '',
        aadhaarBack: json['aadhaar_back'] ?? '',
        aadhaarVerified2: json['aadhaar_verified'] ?? '',
        dlNumber: json['dl_number'] ?? '',
        drivingLicense: json['driving_license'] ?? '',
        drivingLicenseVerified: json['driving_license_verified'] ?? '',
        emailVerified: json['email_verified'],
        profileImage: json['profile_image'] ?? '');
  }

  @override
  String toString() {
    return 'UserModel(mobile: $mobile, firstname: $firstname, lastname: $lastname, email: $email, aadhaarVerified: $aadhaarVerified, dlVerified: $dlVerified, token: $token, emergencyMobile: $emergencyMobile, emergencyName: $emergencyName, emergencyRelation: $emergencyRelation, emergencyMobileVerified: $emergencyMobileVerified, currentAddressHouse: $currentAddressHouse, currentAddressArea: $currentAddressArea, currentAddressLandmark: $currentAddressLandmark, currentAddressCity: $currentAddressCity, permanentAddressHouse: $permanentAddressHouse, permanentAddressArea: $permanentAddressArea, permanentAddressLandmark: $permanentAddressLandmark, permanentAddressCity: $permanentAddressCity, aadhaarNumber: $aadhaarNumber, aadhaarFront: $aadhaarFront, aadhaarBack: $aadhaarBack, aadhaarVerified2: $aadhaarVerified2, dlNumber: $dlNumber, drivingLicense: $drivingLicense, drivingLicenseVerified: $drivingLicenseVerified, profileImage: $profileImage, emailVerified: $emailVerified)';
  }
}
