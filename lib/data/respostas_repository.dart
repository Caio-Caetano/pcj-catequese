import 'package:cloud_firestore/cloud_firestore.dart';

class RespostasRepository {
  Future<List<Map<String, dynamic>>> getAllInscricoes() async {
    List<Map<String, dynamic>> listaInscricoes = [];
    var inscricoes = await FirebaseFirestore.instance.collection('inscricoes').get();
    for (var inscricao in inscricoes.docs) {
      listaInscricoes.add(inscricao.data());
    }
    return listaInscricoes;
  }
}
