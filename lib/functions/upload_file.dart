import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class UploadFile {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> upload(String nome, PlatformFile file, String folder, String etapa) async {
    final fileBytes = file.bytes;
    final fileName = file.name;
    try {
      final ref = _storage.ref().child('docs/$etapa/$nome/$folder/$fileName');
      final snapshot = await ref.putData(fileBytes!);
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao realizar o upload');
      }
    }
    return null;
  }
}
