// ignore_for_file: file_names

class Constants {
  bool get ridobikoURL => true;
  String get _firstURL => 'https://www.ridobiko.com/';
  String get _secondURL => 'https://www.twowheelerrental.in/';
  String get url => ridobikoURL ? _firstURL : _secondURL;
  static String wentWrong = "Something went wrong please try again.";
  static String checkPhone = "Enter a valid mobile number";
}
