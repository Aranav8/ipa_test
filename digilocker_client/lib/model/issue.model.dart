// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Issuer {
  String? name;
  String? description;
  String? issuerid;
  String? issuer_id;
  String? orgid;
  String? logo;
  Issuer({
    this.name,
    this.description,
    this.issuerid,
    this.issuer_id,
    this.orgid,
    this.logo,
  });

  Issuer copyWith({
    String? name,
    String? description,
    String? issuerid,
    String? issuer_id,
    String? orgid,
    String? logo,
  }) {
    return Issuer(
      name: name ?? this.name,
      description: description ?? this.description,
      issuerid: issuerid ?? this.issuerid,
      issuer_id: issuer_id ?? this.issuer_id,
      orgid: orgid ?? this.orgid,
      logo: logo ?? this.logo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'issuerid': issuerid,
      'issuer_id': issuer_id,
      'orgid': orgid,
      'logo': logo,
    };
  }

  factory Issuer.fromMap(Map<String, dynamic> map) {
    return Issuer(
      name: map['name'] != null ? map['name'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      issuerid: map['issuerid'] != null ? map['issuerid'] as String : null,
      issuer_id: map['issuer_id'] != null ? map['issuer_id'] as String : null,
      orgid: map['orgid'] != null ? map['orgid'] as String : null,
      logo: map['logo'] != null ? map['logo'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Issuer.fromJson(String source) =>
      Issuer.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Issuer(name: $name, description: $description, issuerid: $issuerid, issuer_id: $issuer_id, orgid: $orgid, logo: $logo)';
  }

  @override
  bool operator ==(covariant Issuer other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.description == description &&
        other.issuerid == issuerid &&
        other.issuer_id == issuer_id &&
        other.orgid == orgid &&
        other.logo == logo;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        description.hashCode ^
        issuerid.hashCode ^
        issuer_id.hashCode ^
        orgid.hashCode ^
        logo.hashCode;
  }
}
