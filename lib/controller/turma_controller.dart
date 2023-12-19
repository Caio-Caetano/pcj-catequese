import 'package:webapp/data/turma_repository.dart';
import 'package:webapp/model/turma_model.dart';

class TurmaController {
  final TurmaRepository _repository;
  TurmaController(this._repository);

  Future<List<TurmaModel>> getAllTurmas() async => await _repository.getAllTurmas();
}