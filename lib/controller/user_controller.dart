import 'package:webapp/data/user_repository.dart';
import 'package:webapp/model/user_model.dart';

class UserController {
  final UserRepository _userRepository;
  UserController(this._userRepository);

  Future<String> createUser(UserModel model) async => await _userRepository.userAdd(model);
}