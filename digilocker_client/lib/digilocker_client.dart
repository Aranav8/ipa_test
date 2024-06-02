// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:digilocker_client/model/document.model.dart';
import 'package:http/http.dart' as http;
import 'package:digilocker_client/model/issue.model.dart';
import 'package:digilocker_client/digilocker_interfact.dart';
import 'package:digilocker_client/model/Aadhaar.dart';
import 'package:xml2json/xml2json.dart';

class DigiLocker implements IDigiLocker {
  final String URL = 'digilocker.meripehchaan.gov.in';
  late String _clientId;
  late String _clientSecreat;
  late String _redirectUri;
  String _accessToken = '';

  String get token => _accessToken;

  DigiLocker({
    required String clientID,
    required String clientSecret,
    required String callbackUrl,
  }) {
    _clientId = clientID;
    _clientSecreat = clientSecret;
    _redirectUri = callbackUrl;
  }

  set setToken(String token) => _accessToken = token;

  Future<String?> authenticate(
      {required String authCode, String? authCoode}) async {
    final response = await http.post(
      Uri.parse('https://digilocker.meripehchaan.gov.in/public/oauth2/1/token'),
      body: {
        'code': authCode,
        'grant_type': 'authorization_code',
        'client_id': _clientId,
        'client_secret': _clientSecreat,
        'redirect_uri': _redirectUri,
      },
    );
    // Get the access token from the response
    if (response.statusCode == 200) {
      String accessToken = jsonDecode(response.body)['access_token'].toString();
      print(response.body);
      setToken = accessToken;
      print("access token: $accessToken");
    } else {
      final data = jsonDecode(response.body);
      String message = data['error_description'] ?? '';
      return message;
    }
    return null;
  }

  Future<Aadhaar?> getAadhaar() async {
    try {
      Xml2Json xml2json = Xml2Json();
      final response = await http.get(
        Uri.parse(
            'https://digilocker.meripehchaan.gov.in/public/oauth2/3/xml/eaadhaar'),
        headers: {
          "Authorization": "Bearer $_accessToken",
        },
      );
      print(_accessToken);
      print(response.body);
      if (response.statusCode == 200) {
        print(response.body);
        xml2json.parse(response.body);
        var jsondata = xml2json.toGData();
        var data = json.decode(jsondata);
        var img = data['Certificate']['CertificateData']['KycRes']['UidData']
            ['Pht']['\$t'];

        Aadhaar aadhaarData = Aadhaar.fromJson(data);
        print(aadhaarData);
        return aadhaarData;
      }
    } catch (e, stackTrack) {
      print(e.toString());
      throw stackTrack;
    }
    return null;
  }

  Future<String?> hasLicense() async {
    String? dlUri;
    final response1 = await http.get(
      Uri.parse(
          "https://digilocker.meripehchaan.gov.in/public/oauth2/2/files/issued"),
      headers: {"Authorization": "Bearer $_accessToken"},
    );
    if (response1.statusCode == 200) {
      var body = jsonDecode(response1.body);
      var issued = body["items"];
      for (var doc in issued) {
        if (doc["doctype"].toString() == "DRVLC" ||
            doc["description"].toString() == "Driving License") {
          dlUri = doc["uri"].toString();
          return dlUri;
        }
      }
    }
    return null;
  }

  Future<Uint8List?> getDocument(String dlUri) async {
    try {
      final response = await http.get(
        Uri.parse(
            "https://digilocker.meripehchaan.gov.in/public/oauth2/1/file/$dlUri"),
        headers: {"Authorization": "Bearer $_accessToken"},
      );
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {
      print('Error : ${e.toString()}');
    }
    return null;
  }

  @override
  Future<List<Issuer>?> listOfIssuer() async {
    Uri endpoint = Uri.https(
      URL,
      '/public/oauth2/1/pull/issuers',
    );
    DateTime now = DateTime.now();
    int ts = (now.millisecondsSinceEpoch / 1000).floor();
    String hmac = _clientSecreat + _clientId + ts.toString();
    List<int> bytes = utf8.encode(hmac);
    Digest sha256Hmac = sha256.convert(bytes);
    print(sha256Hmac);
    print(ts);
    try {
      http.Response response = await http.post(
        endpoint,
        body: {
          'clientid': _clientId,
          'ts': ts.toString(),
          'hmac': sha256Hmac.toString(),
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)["issuers"];
        List<Issuer> list = [];
        for (var issuer in data) {
          list.add(Issuer.fromMap(issuer));
        }
        if (list.isNotEmpty) return list;
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<Document>?> listOfDocumentByIssuer(String orgId) async {
    Uri endpoint = Uri.https(
      URL,
      '/public/oauth2/1/pull/doctype',
    );
    DateTime now = DateTime.now();
    int ts = (now.millisecondsSinceEpoch / 1000).floor();
    String hmac = _clientSecreat + _clientId + orgId + ts.toString();
    List<int> bytes = utf8.encode(hmac);
    Digest sha256Hmac = sha256.convert(bytes);
    print(sha256Hmac);
    print(ts);
    try {
      http.Response response = await http.post(
        endpoint,
        body: {
          'clientid': _clientId,
          'orgid': orgId,
          'ts': ts.toString(),
          'hmac': sha256Hmac.toString(),
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['documents'];
        List<Document> list = [];
        for (var document in data) {
          list.add(Document.fromMap(document));
        }
        print(list);
        if (list.isNotEmpty) return list;
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<dynamic> getParam(String orgId, String doctype) async {
    Uri endpoint = Uri.https(
      URL,
      '/public/oauth2/1/pull/parameters',
    );
    DateTime now = DateTime.now();
    int ts = (now.millisecondsSinceEpoch / 1000).floor();
    String hmac = _clientSecreat + _clientId + orgId + doctype + ts.toString();
    List<int> bytes = utf8.encode(hmac);
    Digest sha256Hmac = sha256.convert(bytes);
    try {
      // print({
      //   'clientid': _clientId,
      //   'orgid': orgId,
      //   'doctype': doctype,
      //   'ts': ts.toString(),
      //   'hmac': sha256Hmac.toString(),
      // });
      http.Response response = await http.post(
        endpoint,
        body: {
          'clientid': _clientId,
          'orgid': orgId,
          'doctype': doctype,
          'ts': ts.toString(),
          'hmac': sha256Hmac.toString(),
        },
      );

      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        print(response.body);
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  Future<dynamic> pullDocument(Map<String, String> body) async {
    Uri endpoint = Uri.https(
      URL,
      '/public/oauth2/1/pull/pulldocument',
    );
    try {
      http.Response response = await http.post(
        endpoint,
        body: body,
        headers: {
          'Authorization': 'Bearer $_accessToken',
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        return data;
      } else {
        print(response.body);
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  @override
  Future<String?> getAadhar() {
    throw UnimplementedError();
  }
}
