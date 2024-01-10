import 'package:webapp/data/horarios_locais_repository.dart';

class HorariosLocaisController {
  HorariosLocaisController(this._repository);
  final HorariosLocaisRepository _repository;

  Future<List> getHorariosLocais(String etapa) async =>  await _repository.getHorariosLocais(etapa);
  
  Future<void> addHorarioLocais({String? etapa, String? horario}) async => await _repository.addHorarioLocais(etapa: etapa, horario: horario);

  Future<void> deleteHorarioLocais({String? etapa, String? horario}) async => await _repository.deleteHorarioLocais(etapa: etapa, horario: horario);
}
