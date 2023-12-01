import 'package:webapp/data/respostas_repository.dart';

class RespostasController {
  RespostasController(this._repository);
  final RespostasRepository _repository;

  Future<List<Map<String, dynamic>>> getAllRespostas() async => await _repository.getAllInscricoes();

  Future<List<Map<String, dynamic>>> getRespostas({String? etapa}) async => await _repository.getInscricoes(etapa: etapa);

  Future<bool> verificaInscricao(String nome, String telefone) async => await _repository.verificaInscricao(nome, telefone);

  Future<bool> deletarInscricao(String id) async => await _repository.deletarInscricao(id);
}
