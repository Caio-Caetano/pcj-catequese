import 'package:webapp/data/user_repository.dart';
import 'package:webapp/model/user_model.dart';

class UserController {
  final UserRepository _userRepository;
  UserController(this._userRepository);

  Future<String> createUser(UserModel model) async => await _userRepository.userAdd(model);

  Future<List<Map<String, dynamic>>> getUsuarios() async => await _userRepository.getUsers();

  Future<void> editUser(UserModel model, String oldSenha) async => await _userRepository.editUsuario(model, oldSenha);

  Future<bool> deleteUsuario(String id) async => await _userRepository.deleteUsuario(id);
}