import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:webapp/model/user_model.dart';
import 'package:webapp/pages/widgets/text_field_custom.dart';
import 'package:webapp/viewmodels/auth_view_model.dart';

void configureModalBottomSheet(BuildContext context, Function(int, String?, String?) onLogin) {
  final GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
  showModalBottomSheet(
      constraints: const BoxConstraints(minWidth: 350.0, maxWidth: 580.0),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(35.0),
        topRight: Radius.circular(35.0),
      )),
      backgroundColor: const Color(0xFFF3EDC8),
      context: context,
      builder: (BuildContext bc) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF570808),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35.0),
                        topRight: Radius.circular(35.0),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Entrar como catequista',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFF3EDC8),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            authViewModel.logingIn
                ? const Center(child: CircularProgressIndicator())
                : ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 300.0, maxWidth: 520.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                      child: Form(
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
                            ).animate().moveY(duration: 400.milliseconds, delay: 100.milliseconds).fade(duration: 300.milliseconds),
                            TextFieldCustom(
                              controller: passwordController,
                              validator: (value) => value == null || value.isEmpty ? '⚠️ Campo obrigatório' : null,
                              labelText: 'Senha',
                              iconPrefix: const Icon(Icons.password),
                              labelColor: Colors.black,
                              isPassword: true,
                            ).animate().moveY(duration: 400.milliseconds, delay: 500.milliseconds).fade(),
                          ],
                        ),
                      ),
                    ),
                  ),
            if (!authViewModel.logingIn)
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color(0xFFBF3131))),
                          onPressed: () async {
                            if (keyForm.currentState!.validate()) {
                              final authViewModel2 = context.read<AuthViewModel>();
                              final result = await authViewModel.login(UserModel(
                                username: usernameController.text.toLowerCase().trim(),
                                senha: passwordController.text.trim(),
                              ));
                              if (result != null) {
                                onLogin(result.level ?? 0, result.nome, '${result.etapa} - ${result.etapaCoord}');
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
                          child: const Text(
                            'Entrar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ).animate().moveY(duration: 400.milliseconds, delay: 900.milliseconds).fade(duration: 300.milliseconds),
                    ],
                  ),
                ),
              ),
          ],
        );
      });
}
