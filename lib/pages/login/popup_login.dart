import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp/model/user_model.dart';
import 'package:webapp/pages/widgets/text_field_custom.dart';
import 'package:webapp/viewmodels/auth_view_model.dart';

class PopUpLogin extends StatelessWidget {
  final VoidCallback onLogin;
  const PopUpLogin({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final GlobalKey<FormState> keyForm = GlobalKey<FormState>();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return AlertDialog(
      scrollable: true,
      backgroundColor: Colors.white,
      title: const Text('Login'),
      content: Padding(
        padding: const EdgeInsets.all(5),
        child: authViewModel.logingIn
            ? const Center(child: Text('Logando...'))
            : Form(
                key: keyForm,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFieldCustom(
                      controller: usernameController,
                      validator: (value) => value == null || value.isEmpty ? '⚠️ Campo obrigatório' : null,
                      labelText: 'Usuário',
                      iconPrefix: const Icon(Icons.person),
                      labelColor: Colors.black,
                    ),
                    TextFieldCustom(
                      controller: passwordController,
                      validator: (value) => value == null || value.isEmpty ? '⚠️ Campo obrigatório' : null,
                      labelText: 'Senha',
                      iconPrefix: const Icon(Icons.password),
                      labelColor: Colors.black,
                      isPassword: true,
                    ),
                  ],
                ),
              ),
      ),
      actions: [
        authViewModel.logingIn
            ? Container()
            : ElevatedButton(
                onPressed: () async {
                  if (keyForm.currentState!.validate()) {
                    final authViewModel2 = context.read<AuthViewModel>();
                    final result = await authViewModel.login(UserModel(
                      username: usernameController.text.trim(),
                      senha: passwordController.text.trim(),
                    ));
                    if (result) {
                      onLogin();
                    } else {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        elevation: 8,
                        content: Text('Credenciais inválidas.'),
                      ));
                      authViewModel2.logingIn = false;
                    }
                  }
                },
                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)),
                child: const Text('Login', style: TextStyle(color: Colors.white)),
              )
      ],
    );
  }
}
