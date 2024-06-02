import 'dart:convert';
import 'dart:typed_data';

class Aadhaar {
  final String name;
  final String dob;
  final Uint8List photo;
  final String uid;
  final String gender;
  final String co;
  final String country;
  final String dist;
  final String loc;
  final String pc;
  final String state;
  final String vtc;
  final String house;
  final String street;
  final String lm;

  Aadhaar(
      {required this.name,
      required this.dob,
      required this.photo,
      required this.uid,
      required this.gender,
      required this.co,
      required this.country,
      required this.dist,
      required this.loc,
      required this.pc,
      required this.state,
      required this.vtc,
      required this.house,
      required this.street,
      required this.lm});

  factory Aadhaar.fromJson(Map<String, dynamic> map) {
    var poi = map['Certificate']['CertificateData']['KycRes']['UidData']['Poi'];
    var address =
        map['Certificate']['CertificateData']['KycRes']['UidData']['Poa'];
    //print(address);
    return Aadhaar(
        uid: map['Certificate']['CertificateData']['KycRes']['UidData']['uid'],
        name: poi['name'],
        photo: base64Decode(map['Certificate']['CertificateData']['KycRes']
            ['UidData']['Pht']['\$t']),
        dob: poi['dob'],
        gender: poi['gender'] == 'M' ? "MALE" : "FEMALE",
        co: address['co'] ?? "",
        country: address['country'] ?? "",
        dist: address['dist'] ?? "",
        loc: address['loc'] ?? "",
        pc: address["pc"] ?? "",
        state: address["state"] ?? "",
        vtc: address["vtc"] ?? "",
        house: address["house"] ?? "",
        street: address["street"] ?? "",
        lm: address["lm"] ?? "");
  }
}
