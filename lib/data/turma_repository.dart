import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webapp/model/turma_model.dart';

class TurmaRepository {
  Future<List<TurmaModel>> getAllTurmas() async {
    List<TurmaModel> listaTurmas = [];
    var turmas = await FirebaseFirestore.instance.collection('turmas').get();
    for (var turma in turmas.docs) {
      Map<String, dynamic> turmaData = turma.data();
      turmaData['id'] = turma.id;
      TurmaModel model = TurmaModel.fromMap(turmaData);
      listaTurmas.add(model);
    }
    return listaTurmas;
  }
}
