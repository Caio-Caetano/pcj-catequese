import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webapp/model/turma_model.dart';

class RespostasRepository {
  var fireInstance = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _getAllInscricoes() async {
    List<Map<String, dynamic>> listaInscricoes = [];
    // var inscricoes = await fireInstance.collection('testes').get();
    var inscricoes = await fireInstance.collection('inscricoes').get();
    for (var inscricao in inscricoes.docs) {
      Map<String, dynamic> inscricaoData = inscricao.data();
      inscricaoData['id'] = inscricao.id;
      DocumentReference? teste = inscricaoData['turma'];
      var i = await teste?.get();
      inscricaoData['turma'] = i?.data();

      if (inscricaoData['turma']?['catequistas'].isEmpty ?? false) {
        var docRef = fireInstance.collection('turmas').doc(i?.id);
        var result = await fireInstance.collection('inscricoes').where('turma', isEqualTo: docRef).get();
        for (var r in result.docs) {
          await fireInstance.collection('inscricoes').doc(r.id).update({'turma': null});
        }
      }

      listaInscricoes.add(inscricaoData);
    }
    return listaInscricoes;
  }

  Future<List<Map<String, dynamic>>> getInscricoes({String? etapa, bool? archived = false}) async {
    List<Map<String, dynamic>> listaInscricoes = [];
    archived ??= false;
    var inscricoes = await _getAllInscricoes();

    if (etapa == null) {
      listaInscricoes = inscricoes;
      if (archived) {
        listaInscricoes = listaInscricoes.where((element) {
          bool isNowArchived = true;
          if (element['archived'] != null) {
            isNowArchived = element['archived']['isNowArchived'];
          }
          return element['archived'] != null && isNowArchived;
        }).toList();
      } else {
        listaInscricoes = listaInscricoes.where((element) {
          bool isNowArchived = false;
          if (element['archived'] != null) {
            isNowArchived = element['archived']['isNowArchived'];
          }
          return element['archived'] == null || !isNowArchived;
        }).toList();
      }
    } else {
      for (var e in inscricoes) {
        if (e['etapa'] != null) {
          if (e['etapa'].contains(etapa)) {
            listaInscricoes.add(e);
          }
        }
      }
    }
    return listaInscricoes;
  }

  Future<bool> verificaInscricao(String nome, String telefone) async {
    // var inscricao = await fireInstance.collection('testes').where('nome', isEqualTo: nome).where('telefone', isEqualTo: telefone).get();
    var inscricao = await fireInstance.collection('inscricoes').where('nome', isEqualTo: nome).where('telefone', isEqualTo: telefone).get();
    if (inscricao.docs.isEmpty) {
      return true;
    }
    return false;
  }

  // Future<bool> deletarInscricao(String id) async => await fireInstance.collection('testes').doc(id).delete().then((value) => true).catchError((error) => false);
  Future<bool> deletarInscricao(String id) async => await fireInstance.collection('inscricoes').doc(id).delete().then((value) => true).catchError((error) => false);

  // Future<bool> updateInscricaoTurma(String id, TurmaModel turma) async {
  //   DocumentReference ref = fireInstance.collection('turmas').doc(turma.id);
  //   return await fireInstance.collection('testes').doc(id).update({'turma': ref}).then((value) => true).catchError((error) => false);
  // }
  Future<bool> updateInscricaoTurma(String id, TurmaModel turma) async {
    DocumentReference ref = fireInstance.collection('turmas').doc(turma.id);
    return await fireInstance.collection('inscricoes').doc(id).update({'turma': ref}).then((value) => true).catchError((error) => false);
  }

  // Future<bool> archiveInscricao(String id, String reason, bool? isArchived) async {
  //   bool archived = isArchived ?? false;
  //   return await fireInstance
  //       .collection('testes')
  //       .doc(id)
  //       .update({
  //         'archived': {
  //           'isNowArchived': isArchived == null ? false : !archived,
  //           'reasons': FieldValue.arrayUnion(['${DateTime.now()} - ${!archived ? 'Arquivado' : 'Restaurado'} - $reason'])
  //         },
  //         'turma': null
  //       })
  //       .then((value) => true)
  //       .catchError((error) => false);
  // }
  Future<bool> archiveInscricao(String id, String reason, bool? isArchived) async {
    bool archived = isArchived ?? false;
    return await fireInstance
        .collection('inscricoes')
        .doc(id)
        .update({
          'archived': {
            'isNowArchived': isArchived == null ? false : !archived,
            'reasons': FieldValue.arrayUnion(['${DateTime.now()} - ${!archived ? 'Arquivado' : 'Restaurado'} - $reason'])
          },
          'turma': null
        })
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<List<Map<String, dynamic>>> getInscricoesByTurma(TurmaModel model) async {
    DocumentReference ref = fireInstance.collection('turmas').doc(model.id);
    // var inscricoes = await fireInstance.collection('testes').where('turma', isEqualTo: ref).get();
    var inscricoes = await fireInstance.collection('inscricoes').where('turma', isEqualTo: ref).get();
    List<Map<String, dynamic>> listaInscricoes = [];
    for (var inscricao in inscricoes.docs) {
      Map<String, dynamic> inscricaoData = inscricao.data();
      inscricaoData['id'] = inscricao.id;
      listaInscricoes.add(inscricaoData);
    }
    return listaInscricoes;
  }
}
