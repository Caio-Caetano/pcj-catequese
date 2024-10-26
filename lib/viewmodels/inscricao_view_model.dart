import 'package:flutter/material.dart';
import 'package:webapp/model/inscricao_model.dart';

class InscricaoProvider with ChangeNotifier {
  final InscricaoModel _inscricaoInfo = InscricaoModel();

  InscricaoModel get inscricaoInfo => _inscricaoInfo;

  void updateNascimento(InscricaoModel model) {
    _inscricaoInfo.dataNascimento = model.dataNascimento;
    notifyListeners();
    _inscricaoInfo.idade = model.idade;
    notifyListeners();
  }

  void updateNomes(InscricaoModel model) {
    _inscricaoInfo.nome = model.nome;
    notifyListeners();
    _inscricaoInfo.nomeMae = model.nomeMae;
    notifyListeners();
    _inscricaoInfo.nomePai = model.nomePai;
    notifyListeners();
    _inscricaoInfo.nomeResponsavel = model.nomeResponsavel;
    notifyListeners();
  }

  void updateEndereco(Map<String, String>? endereco) {
    _inscricaoInfo.endereco = endereco;
    notifyListeners();
  }

  void updateContato(String? email, String? telefone) {
    _inscricaoInfo.telefone = telefone;
    notifyListeners();
    _inscricaoInfo.email = email;
    notifyListeners();
  }

  void updateBatismo(Map<String, dynamic>? batismo) {
    _inscricaoInfo.batismo = batismo;
    notifyListeners();
  }

  void updateEucaristia(Map<String, dynamic>? eucaristia) {
    _inscricaoInfo.eucaristia = eucaristia;
    notifyListeners();
  }

  void updateLocal(String? local) {
    _inscricaoInfo.local = local;
    notifyListeners();
  }

  void updateEtapa(String? etapa) {
    _inscricaoInfo.etapa = etapa;
    notifyListeners();
  }

  void updateDtInscricao(String? dataInscricao) {
    _inscricaoInfo.dataInscricao = dataInscricao;
    notifyListeners();
  }

  void updateAdicionalAdulto(Map<String, dynamic>? addAdulto) {
    _inscricaoInfo.addAdulto = addAdulto;
    notifyListeners();
  }
}