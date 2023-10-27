// ignore_for_file: public_member_api_docs, sort_constructors_first
class InscricaoModel {
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

  @override
  String toString() {
    return 'InscricaoModel(dataNascimento: $dataNascimento, idade: $idade, etapa: $etapa, nome: $nome, nomeMae: $nomeMae, nomePai: $nomePai, nomeResponsavel: $nomeResponsavel, endereco: $endereco, telefone: $telefone, email: $email, batismo: $batismo, eucaristia: $eucaristia, local: $local)';
  }
}
