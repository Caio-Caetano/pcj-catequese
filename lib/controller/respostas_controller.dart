import 'package:webapp/data/respostas_repository.dart';

class RespostasController {
  RespostasRepository repository = RespostasRepository();
  Future<List<Map<String, dynamic>>> getAllRespostas() async {
    return await repository.getAllInscricoes();
  }
}