import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class InscricaoModel {
  String? dataInscricao;

  String? dataNascimento;
  String? idade;
  String? etapa;

  String? nome;
  String? nomeMae;
  String? nomePai;
  String? nomeResponsavel;

  Map<String, String>? endereco;

  String? telefone;
  String? email;

  Map<String, dynamic>? batismo;
  Map<String, dynamic>? eucaristia;

  String? local;
  
  InscricaoModel({
    this.dataInscricao,
    this.dataNascimento,
    this.idade,
    this.etapa,
    this.nome,
    this.nomeMae,
    this.nomePai,
    this.nomeResponsavel,
    this.endereco,
    this.telefone,
    this.email,
    this.batismo,
    this.eucaristia,
    this.local,
  });

  @override
  String toString() {
    return 'InscricaoModel(dataInscricao: $dataInscricao dataNascimento: $dataNascimento, idade: $idade, etapa: $etapa, nome: $nome, nomeMae: $nomeMae, nomePai: $nomePai, nomeResponsavel: $nomeResponsavel, endereco: $endereco, telefone: $telefone, email: $email, batismo: $batismo, eucaristia: $eucaristia, local: $local)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dataInscricao': dataInscricao,
      'dataNascimento': dataNascimento,
      'idade': idade,
      'etapa': etapa,
      'nome': nome,
      'nomeMae': nomeMae,
      'nomePai': nomePai,
      'nomeResponsavel': nomeResponsavel,
      'endereco': endereco,
      'telefone': telefone,
      'email': email,
      'batismo': batismo,
      'eucaristia': eucaristia,
      'local': local,
    };
  }

  factory InscricaoModel.fromMap(Map<String, dynamic> map) {
    return InscricaoModel(
      dataInscricao: map['dataInscricao'] != null ? map['dataInscricao'] as String : null,
      dataNascimento: map['dataNascimento'] != null ? map['dataNascimento'] as String : null,
      idade: map['idade'] != null ? map['idade'] as String : null,
      etapa: map['etapa'] != null ? map['etapa'] as String : null,
      nome: map['nome'] != null ? map['nome'] as String : null,
      nomeMae: map['nomeMae'] != null ? map['nomeMae'] as String : null,
      nomePai: map['nomePai'] != null ? map['nomePai'] as String : null,
      nomeResponsavel: map['nomeResponsavel'] != null ? map['nomeResponsavel'] as String : null,
      endereco: map['endereco'] != null ? Map<String, String>.from((map['endereco'] as Map<String, String>)) : null,
      telefone: map['telefone'] != null ? map['telefone'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      batismo: map['batismo'] != null ? Map<String, dynamic>.from((map['batismo'] as Map<String, dynamic>)) : null,
      eucaristia: map['eucaristia'] != null ? Map<String, dynamic>.from((map['eucaristia'] as Map<String, dynamic>)) : null,
      local: map['local'] != null ? map['local'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory InscricaoModel.fromJson(String source) => InscricaoModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
