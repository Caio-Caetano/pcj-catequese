import 'package:cloud_firestore/cloud_firestore.dart';

class HorariosLocaisRepository {
  Future<List> getHorariosLocais(String etapa) async {
    var horariosLocais = await FirebaseFirestore.instance.collection('horarioslocais').doc(etapa).get();
    return horariosLocais.data() == null ? [] : horariosLocais.data()!['horarios'];
  }

  Future<void> addHorarioLocais({String? etapa, String? horario}) async {
    var horariosLocais = FirebaseFirestore.instance.collection('horarioslocais').doc(etapa);
    await horariosLocais.update({
      'horarios' : FieldValue.arrayUnion([horario])
    });
  }

  Future<void> deleteHorarioLocais({String? etapa, String? horario}) async {
    var horariosLocais = FirebaseFirestore.instance.collection('horarioslocais').doc(etapa);
    await horariosLocais.update({
      'horarios' : FieldValue.arrayRemove([horario])
    });
  }
}
