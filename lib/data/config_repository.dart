import 'package:cloud_firestore/cloud_firestore.dart';

class ConfigRepository {
  Future<Map<String, dynamic>> getFormAberto() async {
    var configFormAberto = await FirebaseFirestore.instance.collection('configs').doc('configs').get();
    Map<String, dynamic>? retorno = configFormAberto.data();
    return retorno ?? {};
  }

  Future<void> updateFormAberto() async {
    var configFormAberto = await FirebaseFirestore.instance.collection('configs').doc('configs').get();
    Map<String, dynamic>? retorno = configFormAberto.data();
    bool open = retorno?['formOpen'] ?? false;
    await FirebaseFirestore.instance.collection('configs').doc('configs').update({
      'formOpen' : !open,
      'eucaristia' : open ? false : true,
      'crisma' : open ? false : true,
      'jovens' : open ? false : true,
      'adultos' : open ? false : true,
    });
  }

  Future<void> updateFormEspecifico({String? etapa}) async {
    if (etapa == null) return;
    var configFormAberto = await FirebaseFirestore.instance.collection('configs').doc('configs').get();
    Map<String, dynamic>? retorno = configFormAberto.data();
    bool open = retorno?[etapa] ?? false;
    await FirebaseFirestore.instance.collection('configs').doc('configs').update({etapa : !open});
  }

  Future<void> updateMenssagemFechado({String? novaMensagem}) async {
    if (novaMensagem == null) return;
    await FirebaseFirestore.instance.collection('configs').doc('configs').update({'avisoFechado' : novaMensagem});
  }
}
