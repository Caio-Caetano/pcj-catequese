import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:webapp/controller/respostas_controller.dart';
import 'package:webapp/data/respostas_repository.dart';
import 'package:webapp/model/inscricao_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoadingClass extends ChangeNotifier {
  bool _loading = false;

  get loading => _loading;

  setLoading() {
    _loading = !_loading;
    notifyListeners();
  }

  var colInscricao = dotenv.env['INSCRICAO'] ?? '';

  Future<Map<String, dynamic>> addInscricao(InscricaoModel model) async {
    _loading = true;
    notifyListeners();

    RespostasController controllerRespostas = RespostasController(RespostasRepository());
    var response = await controllerRespostas.verificaInscricao(model.nome!, model.telefone!);
    if (response) {
      CollectionReference inscricoes = FirebaseFirestore.instance.collection(colInscricao);
      return await inscricoes.add(model.toMap()).then((value) {
        _loading = false;
        notifyListeners();
        return {'sucesso': true, 'message': value.id.substring(0, 5)};
      }).catchError((error) {
        _loading = false;
        notifyListeners();
        return {'sucesso': false, 'message': 'Não foi possível adicionar $error'};
      });
    } else {
      _loading = false;
      notifyListeners();
      return {'sucesso': false, 'message': 'Essa pessoa já realizou a inscrição.'};
    }
  }
}
