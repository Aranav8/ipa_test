class CouponModel {
  String coupon;
  String couponImage;
  double amount;
  String startDate;
  String endDate;
  double startPrice;
  String city;
  String? description;
  int used;
  int maxCount;

  CouponModel(
      {required this.coupon,
      required this.couponImage,
      required this.amount,
      required this.startDate,
      required this.endDate,
      required this.startPrice,
      required this.city,
      required this.used,
      required this.maxCount,
      this.description});

  factory CouponModel.fromMap(Map<String, dynamic> map) {
    return CouponModel(
      coupon: map['coupon'] ?? '',
      couponImage: map['coupon_image'] ?? '',
      amount: double.tryParse(map['amount'].toString()) ?? 0,
      startDate: map['start_date'] ?? '',
      endDate: map['end_date'] ?? '',
      startPrice: double.tryParse(map['start_price'].toString()) ?? 0,
      city: map['city'] ?? '',
      used: int.tryParse(map['used'].toString()) ?? 0,
      maxCount: int.tryParse(map['max_count'].toString()) ?? 0,
    );
  }
}
