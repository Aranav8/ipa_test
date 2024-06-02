// ignore_for_file: public_member_api_docs, sort_constructors_first

class GST {
  late String id;
  late double cgst;
  late double sgst;
  late double gst;
  late bool isGSTApplicable;
  late bool isSGSTApplicable;
  late bool isCGSTApplicable;
  GST({
    required this.id,
    required this.cgst,
    required this.sgst,
    required this.gst,
    required this.isGSTApplicable,
    required this.isSGSTApplicable,
    required this.isCGSTApplicable,
  });

  GST copyWith({
    String? id,
    double? cgst,
    double? sgst,
    double? gst,
    bool? isGSTApplicable,
    bool? isSGSTApplicable,
    bool? isCGSTApplicable,
  }) {
    return GST(
      id: id ?? this.id,
      cgst: cgst ?? this.cgst,
      sgst: sgst ?? this.sgst,
      gst: gst ?? this.gst,
      isGSTApplicable: isGSTApplicable ?? this.isGSTApplicable,
      isSGSTApplicable: isSGSTApplicable ?? this.isSGSTApplicable,
      isCGSTApplicable: isCGSTApplicable ?? this.isCGSTApplicable,
    );
  }

  factory GST.fromMap(Map<String, dynamic> map) {
    return GST(
      id: map['id'] ?? '-1',
      cgst: double.tryParse(map['cgst']) ?? 0,
      sgst: double.tryParse(map['sgst']) ?? 0,
      gst: double.tryParse(map['gst']) ?? 0,
      isGSTApplicable: map['gst_flag'] == '1' ? true : false,
      isSGSTApplicable: map['sgst_flag'] == '1' ? true : false,
      isCGSTApplicable: map['cgst_flag'] == '1' ? true : false,
    );
  }
}
