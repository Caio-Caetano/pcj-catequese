import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  // final VoidCallback onLogin;
  final VoidCallback onRegisterClick;
  const LoginPage({super.key, required this.onRegisterClick});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Pastoral catequetica - PCJ', style: Theme.of(context).textTheme.titleLarge),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.login, color: Colors.black),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: onRegisterClick,
              child: const Text('Inscrição', style: TextStyle(fontSize: 24)),
            ),
          ),
        ],
      ),
    );
  }
}
