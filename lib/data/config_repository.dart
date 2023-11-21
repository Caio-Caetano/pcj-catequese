import 'package:cloud_firestore/cloud_firestore.dart';

class ConfigRepository {
  Future<bool> getFormAberto() async {
    var configFormAberto = await FirebaseFirestore.instance.collection('configs').doc('configs').get();
    Map<String, dynamic>? retorno = configFormAberto.data();
    return retorno?['formOpen'] ?? false;
  }

  Future<void> updateFormAberto() async {
    var configFormAberto = await FirebaseFirestore.instance.collection('configs').doc('configs').get();
    Map<String, dynamic>? retorno = configFormAberto.data();
    bool open = retorno?['formOpen'] ?? false;
    await FirebaseFirestore.instance.collection('configs').doc('configs').update({'formOpen' : !open});
  }
}
