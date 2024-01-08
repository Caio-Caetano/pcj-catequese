import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webapp/model/turma_model.dart';

class RespostasRepository {
  Future<List<Map<String, dynamic>>> _getAllInscricoes() async {
    List<Map<String, dynamic>> listaInscricoes = [];
    //var inscricoes = await FirebaseFirestore.instance.collection('testes').get();
    var inscricoes = await FirebaseFirestore.instance.collection('inscricoes').get();
    for (var inscricao in inscricoes.docs) {
      Map<String, dynamic> inscricaoData = inscricao.data();
      inscricaoData['id'] = inscricao.id;
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
    //var inscricao = await FirebaseFirestore.instance.collection('testes').where('nome', isEqualTo: nome).where('telefone', isEqualTo: telefone).get();
    var inscricao = await FirebaseFirestore.instance.collection('inscricoes').where('nome', isEqualTo: nome).where('telefone', isEqualTo: telefone).get();
    if (inscricao.docs.isEmpty) {
      return true;
    }
    return false;
  }

  //Future<bool> deletarInscricao(String id) async => await FirebaseFirestore.instance.collection('testes').doc(id).delete().then((value) => true).catchError((error) => false);
  Future<bool> deletarInscricao(String id) async => await FirebaseFirestore.instance.collection('inscricoes').doc(id).delete().then((value) => true).catchError((error) => false);

  //Future<bool> updateInscricaoTurma(String id, TurmaModel turma) async => await FirebaseFirestore.instance.collection('testes').doc(id).update({'turma': turma.toMap()}).then((value) => true).catchError((error) => false);
  Future<bool> updateInscricaoTurma(String id, TurmaModel turma) async => await FirebaseFirestore.instance.collection('inscricoes').doc(id).update({'turma': turma.toMap()}).then((value) => true).catchError((error) => false);

  // Future<bool> archiveInscricao(String id, String reason, bool? isArchived) async {
  //   bool archived = isArchived ?? false;
  //   return await FirebaseFirestore.instance
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
    return await FirebaseFirestore.instance
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
    //var inscricoes = await FirebaseFirestore.instance.collection('testes').where('turma', isEqualTo: model.toMap()).get();
    var inscricoes = await FirebaseFirestore.instance.collection('inscricoes').where('turma', isEqualTo: model.toMap()).get();
    List<Map<String, dynamic>> listaInscricoes = [];
    for (var inscricao in inscricoes.docs) {
      Map<String, dynamic> inscricaoData = inscricao.data();
      inscricaoData['id'] = inscricao.id;
      listaInscricoes.add(inscricaoData);
    }
    return listaInscricoes;
  }
}
