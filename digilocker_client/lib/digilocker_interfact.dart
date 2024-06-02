import 'package:digilocker_client/model/issue.model.dart';

abstract class IDigiLocker {
  Future<List<Issuer>?> listOfIssuer();
  // Future<List<Document>?> listOfDocumentByIssuer(String orgId);
  Future<String?> getAadhar();
}
