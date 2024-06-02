// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:core';

class VehicleDocumentData {
  String? rc;
  String? insurance;
  String? puc;
  String? purchaseBill;
  String? permitA;
  String? permitB;
  VehicleDocumentData({
    this.rc,
    this.insurance,
    this.puc,
    this.purchaseBill,
    this.permitA,
    this.permitB,
  });

  VehicleDocumentData copyWith({
    String? rc,
    String? insurance,
    String? puc,
    String? purchaseBill,
    String? permitA,
    String? permitB,
  }) {
    return VehicleDocumentData(
      rc: rc ?? this.rc,
      insurance: insurance ?? this.insurance,
      puc: puc ?? this.puc,
      purchaseBill: purchaseBill ?? this.purchaseBill,
      permitA: permitA ?? this.permitA,
      permitB: permitB ?? this.permitB,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'rc': rc,
      'insurance': insurance,
      'puc': puc,
      'purchaseBill': purchaseBill,
      'permitA': permitA,
      'permitB': permitB,
    };
  }

  factory VehicleDocumentData.fromMap(Map<String, dynamic> map) {
    return VehicleDocumentData(
      rc: map['RC'],
      insurance: map['Insurance'],
      puc: map['PUC'],
      purchaseBill: map['Purchase_bill'],
      permitA: map['Permit'],
      permitB: map['permit_bpermit_b'],
    );
  }

  String toJson() => json.encode(toMap());

  factory VehicleDocumentData.fromJson(String source) =>
      VehicleDocumentData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VehicleDocumentData(rc: $rc, insurance: $insurance, puc: $puc, purchaseBill: $purchaseBill, permitA: $permitA, permit_bpermit_b: $permitB)';
  }

  @override
  bool operator ==(covariant VehicleDocumentData other) {
    if (identical(this, other)) return true;

    return other.rc == rc &&
        other.insurance == insurance &&
        other.puc == puc &&
        other.purchaseBill == purchaseBill &&
        other.permitA == permitA &&
        other.permitB == permitB;
  }

  @override
  int get hashCode {
    return rc.hashCode ^
        insurance.hashCode ^
        puc.hashCode ^
        purchaseBill.hashCode ^
        permitA.hashCode ^
        permitB.hashCode;
  }
}
