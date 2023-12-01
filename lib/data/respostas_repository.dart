import 'package:cloud_firestore/cloud_firestore.dart';

class RespostasRepository {
  Future<List<Map<String, dynamic>>> getAllInscricoes() async {
    List<Map<String, dynamic>> listaInscricoes = [];
    var inscricoes = await FirebaseFirestore.instance.collection('inscricoes').get();
    for (var inscricao in inscricoes.docs) {
      Map<String, dynamic> inscricaoData = inscricao.data();
      inscricaoData['id'] = inscricao.id;
      listaInscricoes.add(inscricaoData);
    }
    return listaInscricoes;
  }

  Future<List<Map<String, dynamic>>> getInscricoes({String? etapa}) async {
    List<Map<String, dynamic>> listaInscricoes = [];
    var inscricoes = await getAllInscricoes();
    for (var e in inscricoes) {
      if (e['etapa'].contains(etapa)) {
        listaInscricoes.add(e);
      }
    }
    return listaInscricoes;
  }

  Future<bool> verificaInscricao(String nome, String telefone) async {
    var inscricao = await FirebaseFirestore.instance.collection('inscricoes').where('nome', isEqualTo: nome).where('telefone', isEqualTo: telefone).get();
    if (inscricao.docs.isEmpty) {
      return true;
    }
    return false;
  }

  Future<bool> deletarInscricao(String id) async => await FirebaseFirestore.instance.collection('inscricoes').doc(id).delete().then((value) => true).catchError((error) => false);
}
