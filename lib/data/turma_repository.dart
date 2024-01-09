import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webapp/model/turma_model.dart';

class TurmaRepository {
  var fireInstance = FirebaseFirestore.instance;

  Future<List<TurmaModel>> getAllTurmas({String? etapa}) async {
    List<TurmaModel> listaTurmas = [];
    var turmas = await fireInstance.collection('turmas').get();
    for (var turma in turmas.docs) {
      Map<String, dynamic> turmaData = turma.data();
      turmaData['id'] = turma.id;
      if (etapa == null) {
        TurmaModel model = TurmaModel.fromMap(turmaData);
        listaTurmas.add(model);
      } else {
        if (turmaData['etapa'].contains(etapa)) {
          TurmaModel model = TurmaModel.fromMap(turmaData);
          listaTurmas.add(model);
        }
      }
      if (turmaData['catequistas'].isEmpty) {
        var docRef = fireInstance.collection('turmas').doc(turma.id);
        var result = await fireInstance.collection('testes').where('turma', isEqualTo: docRef).get();
        for (var r in result.docs) {
          await fireInstance.collection('testes').doc(r.id).update({'turma': null});
        }
      }
    }
    return listaTurmas;
  }

  Future<List<TurmaModel>> getTurmas({required String etapa}) async {
    List<TurmaModel> listaTurmas = [];
    var turmas = await FirebaseFirestore.instance.collection('turmas').where('etapa', isEqualTo: etapa).get();
    for (var turma in turmas.docs) {
      Map<String, dynamic> turmaData = turma.data();
      turmaData['id'] = turma.id;
      TurmaModel model = TurmaModel.fromMap(turmaData);
      listaTurmas.add(model);
    }
    return listaTurmas;
  }

  Future<TurmaModel> getTurma(String turmaId) async {
    var turma = await FirebaseFirestore.instance.collection('turmas').doc(turmaId).get();
    Map<String, dynamic> turmaData = turma.data() ?? {};
    turmaData['id'] = turmaId;
    TurmaModel model = TurmaModel.fromMap(turmaData);
    return model;
  }

  Future<List<TurmaModel>> getTurmaByCatequista({required String catequista}) async {
    var turmas = await FirebaseFirestore.instance.collection('turmas').where('catequistas', arrayContains: catequista).get();
    List<TurmaModel> listTurmaModel = [];
    for (var turma in turmas.docs) {
      Map<String, dynamic> turmaData = turma.data();
      turmaData['id'] = turma.id;
      TurmaModel model = TurmaModel.fromMap(turmaData);
      listTurmaModel.add(model);
    }
    return listTurmaModel;
  }

  Future<void> updateTurma({String? local, List? catequistas, required String turmaId}) async {
    var turma = FirebaseFirestore.instance.collection('turmas').doc(turmaId);
    if (local != null && catequistas != null) {
      await turma.update({
        'local': local,
        'catequistas': FieldValue.arrayUnion(catequistas),
      });
    } else if (local != null) {
      await turma.update({
        'local': local,
      });
    } else if (catequistas != null) {
      await turma.update({
        'catequistas': FieldValue.arrayUnion(catequistas),
      });
    }
  }

  Future<void> deleteCatequistaCadastrado({required String catequista, required String turmaId}) async {
    var turma = FirebaseFirestore.instance.collection('turmas').doc(turmaId);
    await turma.update({
      'catequistas': FieldValue.arrayRemove([catequista]),
    });
  }

  Future<void> addTurma(TurmaModel model) async {
    CollectionReference turmaRef = FirebaseFirestore.instance.collection('turmas');
    await turmaRef.add(model.toMap());
  }

  Future<void> deleteTurma(String turmaId) async => await FirebaseFirestore.instance.collection('turmas').doc(turmaId).delete();
}
