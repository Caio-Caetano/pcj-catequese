import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class TurmaModel {
  String? id;
  List? catequistas;
  String? etapa;
  String? local;

  TurmaModel({
    this.id,
    this.catequistas,
    this.etapa,
    this.local,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'catequistas': catequistas, 'etapa': etapa, 'local': local};
  }

  factory TurmaModel.fromMap(Map<String, dynamic> map) {
    return TurmaModel(
        id: map['id'] != null ? map['id'] as String : null,
        catequistas: map['catequistas'] != null ? map['catequistas'] as List : null,
        etapa: map['etapa'] != null ? map['etapa'] as String : null,
        local: map['local'] != null ? map['local'] as String : null,
      );
  }

  String toJson() => json.encode(toMap());

  factory TurmaModel.fromJson(String source) => TurmaModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
