import 'package:webapp/data/config_repository.dart';

class ConfigController {
  final ConfigRepository _repository = ConfigRepository();

  Future<bool> getFormAberto() async => _repository.getFormAberto();

  Future<void> updateFormAberto() async => _repository.updateFormAberto();
}