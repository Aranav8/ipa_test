class Cred {
  bool get isLive => true;
  String get _razorpayTestKey => 'rzp_test_cqDybNWDuOMU06';
  String get _razorpayLiveKey => 'rzp_live_wwpGzdI2GDWS29';
  String get razorpayKey => isLive ? _razorpayLiveKey : _razorpayTestKey;

  String get _paytmTestMID => 'FenWVz44473859719119';
  String get _paytmMID => 'RidoSo26825536677038'; // RidoSo26825536677038

  String get paytmMID => isLive ? _paytmMID : _paytmTestMID;

  String get digilockerClientId => 'FAD70D68';
  String get digilockerClientSecret => 'c159c4a8593902ba9660';
  String get digilockerRedirectUri => 'myapp://example.com/someresource';
  String get callbackUrlScheme => 'myapp';

  //Test Credential
  // $keyId = 'rzp_test_cqDybNWDuOMU06';
  // $keySecret = 'eMIG9JE4xwlWBl6FxcfUvmAg';
//Live Credential
//     $keyId = 'rzp_live_wwpGzdI2GDWS29';
//     $keySecret = 'II29D8pGMGLBYWGZn8qgo2Pq';
}
