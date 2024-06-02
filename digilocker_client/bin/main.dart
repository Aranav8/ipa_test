import 'package:digilocker_client/digilocker_client.dart';

void main(List<String> args) async {
  String clientId = 'FAD70D68';
  String clientSecret = 'c159c4a8593902ba9660';
  DigiLocker obj = DigiLocker(
      clientID: clientId, clientSecret: clientSecret, callbackUrl: '');
  print(await obj.listOfDocumentByIssuer(''));
}
