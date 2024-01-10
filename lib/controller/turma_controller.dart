import 'package:webapp/data/turma_repository.dart';
import 'package:webapp/model/turma_model.dart';

class TurmaController {
  final TurmaRepository _repository;
  TurmaController(this._repository);

  Future<List<TurmaModel>> getAllTurmas({String? etapa}) async => await _repository.getAllTurmas(etapa: etapa);

  Future<List<TurmaModel>> getTurmas({required String etapa}) async => await _repository.getTurmas(etapa: etapa);

  Future<TurmaModel> getTurma(String turmaId) async => await _repository.getTurma(turmaId);

  Future<List<TurmaModel>> getTurmaByCatequista({required String catequista}) async => await _repository.getTurmaByCatequista(catequista: catequista);

  Future<void> addTurma(TurmaModel model) async => await _repository.addTurma(model);

  Future<void> deleteTurma(String turmaId) async => await _repository.deleteTurma(turmaId);

  Future<void> updateTurma(String turmaId, {String? local, List? catequistas}) async => await _repository.updateTurma(turmaId: turmaId, local: local, catequistas: catequistas);

  Future<void> removeCatequistaCadastrado(String turmaId, String catequista) async => await _repository.deleteCatequistaCadastrado(catequista: catequista, turmaId: turmaId);
}