import 'package:webapp/data/respostas_repository.dart';
import 'package:webapp/model/turma_model.dart';

class RespostasController {
  RespostasController(this._repository);
  final RespostasRepository _repository;

  Future<List<Map<String, dynamic>>> getRespostas({String? etapa, bool? archived}) async => await _repository.getInscricoes(etapa: etapa, archived: archived);

  Future<bool> verificaInscricao(String nome, String telefone) async => await _repository.verificaInscricao(nome, telefone);

  Future<bool> deletarInscricao(String id) async => await _repository.deletarInscricao(id);

  Future<bool> updateInscricaoTurma(String id, TurmaModel turma) async => await _repository.updateInscricaoTurma(id, turma);

  Future<bool> archiveInscricao(String id, String reason, bool? isArchived) async => await _repository.archiveInscricao(id, reason, isArchived);

  Future<List<Map<String, dynamic>>> getInscricoesByTurma(TurmaModel model) async => await _repository.getInscricoesByTurma(model);
}
