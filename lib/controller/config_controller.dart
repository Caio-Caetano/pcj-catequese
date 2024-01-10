import 'package:webapp/data/config_repository.dart';

class ConfigController {
  final ConfigRepository _repository = ConfigRepository();

  Future<Map<String, dynamic>> getFormAberto() async => _repository.getFormAberto();

  Future<void> updateFormAberto() async => _repository.updateFormAberto();

  Future<void> updateFormEspecifico(String? etapa) async => _repository.updateFormEspecifico(etapa: etapa);

  Future<void> updateMensagemFechado(String novaMensagem) async => await _repository.updateMenssagemFechado(novaMensagem: novaMensagem);
}