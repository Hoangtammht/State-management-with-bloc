import 'package:blocstatemanagement/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

typedef OnLoginTapped = void Function(String email, String password);

class LoginButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final OnLoginTapped onLoginTapped;

  const LoginButton({super.key,
    required this.emailController,
    required this.passwordController,
    required this.onLoginTapped});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          final email = emailController.text;
          final password = passwordController.text;
          if (email.isEmpty || password.isEmpty) {
            showGenericDialog<bool>(context: context,
                title: 'Please fill in both email and the password fields',
                content: 'You seem to have forgotten to enter either the email or the password field, or both.Please try again.',
                optionBuilder: () => {
                  "OK": true
                });
          }else{
            onLoginTapped(
              email,
              password
            );
          }
        },
        child: const Text('Login'));
  }
}
