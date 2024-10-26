import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webapp/model/inscricao_model.dart';
import 'package:webapp/model/turma_model.dart';

class RespostasRepository {
  var fireInstance = FirebaseFirestore.instance;
  var colInscricao = 'inscricoes2025';

  Future<List<Map<String, dynamic>>> _getAllInscricoes(
      {String? collection}) async {
    collection = collection ?? colInscricao;

    List<Map<String, dynamic>> listaInscricoes = [];

    try {
      var inscricoes = await fireInstance.collection(collection).get();
      for (var inscricao in inscricoes.docs) {
        Map<String, dynamic> inscricaoData = inscricao.data();
        inscricaoData['id'] = inscricao.id;
        DocumentReference? teste = inscricaoData['turma'];
        var i = await teste?.get();
        inscricaoData['turma'] = i?.data();

        if (inscricaoData['turma']?['catequistas'].isEmpty ?? false) {
          var docRef = fireInstance.collection('turmas').doc(i?.id);
          var result = await fireInstance
              .collection(collection)
              .where('turma', isEqualTo: docRef)
              .get();
          for (var r in result.docs) {
            await fireInstance
                .collection(collection)
                .doc(r.id)
                .update({'turma': null});
          }
        }

        listaInscricoes.add(inscricaoData);
      }
      return listaInscricoes;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getInscricoes(
      {String? etapa, bool? archived = false, String? collection}) async {
    List<Map<String, dynamic>> listaInscricoes = [];
    archived ??= false;
    var inscricoes = await _getAllInscricoes(collection: collection);

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

  Future<bool> verificaInscricao(String nome, String telefone,
      {String? collection}) async {
    collection = collection ?? colInscricao;
    var inscricao = await fireInstance
        .collection(collection)
        .where('nome', isEqualTo: nome)
        .where('telefone', isEqualTo: telefone)
        .get();
    if (inscricao.docs.isEmpty) {
      return true;
    }
    return false;
  }

  Future<bool> deletarInscricao(String id) async => await fireInstance
      .collection(colInscricao)
      .doc(id)
      .delete()
      .then((value) => true)
      .catchError((error) => false);

  Future<bool> updateInscricaoTurma(String id, TurmaModel turma) async {
    DocumentReference ref = fireInstance.collection('turmas').doc(turma.id);
    return await fireInstance
        .collection(colInscricao)
        .doc(id)
        .update({'turma': ref})
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> archiveInscricao(
      String id, String reason, bool? isArchived) async {
    bool archived = isArchived ?? false;
    return await fireInstance
        .collection(colInscricao)
        .doc(id)
        .update({
          'archived': {
            'isNowArchived': isArchived == null ? false : !archived,
            'reasons': FieldValue.arrayUnion([
              '${DateTime.now()} - ${!archived ? 'Arquivado' : 'Restaurado'} - $reason'
            ])
          },
          'turma': null
        })
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<List<Map<String, dynamic>>> getInscricoesByTurma(
      TurmaModel model) async {
    DocumentReference ref = fireInstance.collection('turmas').doc(model.id);
    var inscricoes = await fireInstance
        .collection(colInscricao)
        .where('turma', isEqualTo: ref)
        .get();
    List<Map<String, dynamic>> listaInscricoes = [];
    for (var inscricao in inscricoes.docs) {
      Map<String, dynamic> inscricaoData = inscricao.data();
      inscricaoData['id'] = inscricao.id;
      listaInscricoes.add(inscricaoData);
    }
    return listaInscricoes;
  }

  Future<List<Map<String, dynamic>>> inserirInscricao(
      List<InscricaoModel> model,
      {String? collection}) async {
    List<Map<String, dynamic>> retorno = [];
    collection = collection ?? colInscricao;

    for (var i in model) {
      // Verifica a data de nascimento para ajustar a idade
      List<String> partesData = i.dataNascimento!.split('/');
      DateTime dataNascimento = DateTime.parse('${partesData[2]}-${partesData[1]}-${partesData[0]}'); // Converte para yyyy-mm-dd
      DateTime hoje = DateTime.now();
      if (dataNascimento.month == hoje.month &&
          dataNascimento.day == hoje.day) {
        i.idade = (int.parse(i.idade!) + 1).toString(); // Aumenta a idade se for o aniversário
      }

      // Verifica e ajusta a etapa
      if (i.etapa!.contains('Crisma')) {
        if (i.etapa!.startsWith('3º')) {
          retorno.add({
            'nome': i.nome,
            'sucesso': false,
            'message': 'Não é possível avançar na etapa da Crisma.'
          });
          continue; // Pula para o próximo loop
        } else {
          // Avança a etapa da Crisma
          String novaEtapa =
              '${int.parse(i.etapa![0]) + 1}º Etapa - Crisma';
          i.etapa = novaEtapa;
        }
      } else if (i.etapa!.contains('Eucaristia')) {
        if (i.etapa!.startsWith('3º')) {
          i.etapa = '1º Etapa - Crisma'; // Avança da Eucaristia para a Crisma
        } else {
          // Avança a etapa da Eucaristia
          String novaEtapa =
              '${int.parse(i.etapa![0]) + 1}º Etapa - Eucaristia';
          i.etapa = novaEtapa;
        }
      }

      // Verifica se a inscrição já existe
      var response =
          await verificaInscricao(i.nome!, i.telefone!, collection: collection);
      if (response) {
        CollectionReference inscricoes =
            FirebaseFirestore.instance.collection(collection);
        await inscricoes.add(i.toMap()).then((value) {
          retorno.add({
            'id': value.id,
            'sucesso': true,
            'message': value.id.substring(0, 5)
          });
        }).catchError((error) {
          retorno.add({
            'nome': i.nome,
            'sucesso': false,
            'message': 'Não foi possível adicionar $error'
          });
        });
      } else {
        retorno.add({
          'nome': i.nome,
          'sucesso': false,
          'message': 'Essa pessoa já realizou a inscrição.'
        });
      }
    }
    return retorno;
  }
}
