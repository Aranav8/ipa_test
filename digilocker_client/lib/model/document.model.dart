import 'dart:convert';

class Document {
  String doctype;
  String description;
  String logo;
  Document({
    required this.doctype,
    required this.description,
    required this.logo,
  });

  Document copyWith({
    String? doctype,
    String? description,
    String? logo,
  }) {
    return Document(
      doctype: doctype ?? this.doctype,
      description: description ?? this.description,
      logo: logo ?? this.logo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'doctype': doctype,
      'description': description,
      'logo': logo,
    };
  }

  factory Document.fromMap(Map<String, dynamic> map) {
    return Document(
      doctype: map['doctype'] as String,
      description: map['description'] as String,
      logo: map['logo'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Document.fromJson(String source) =>
      Document.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Document(doctype: $doctype, description: $description, logo: $logo)';

  @override
  bool operator ==(covariant Document other) {
    if (identical(this, other)) return true;

    return other.doctype == doctype &&
        other.description == description &&
        other.logo == logo;
  }

  @override
  int get hashCode => doctype.hashCode ^ description.hashCode ^ logo.hashCode;
}
