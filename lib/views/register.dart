import 'package:flutter/material.dart';
import 'package:notesapp_learning/constants/routes.dart';
import 'package:notesapp_learning/services/auth/auth_service.dart';
import 'package:notesapp_learning/utilities/show_error_dialog.dart';
import '../services/auth/auth_exception.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Email'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: 'Password'),
          ),
          TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  final userCredential =
                      await AuthService.firebase().createUser(
                    email: email,
                    password: password,
                  );

                  AuthService.firebase().sendEmailVerification();
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                } on WeakPasswordAuthException {
                  await showErrorDialog(context, 'Password is too weak');
                } on EmailAlreadyInUseAuthException {
                  await showErrorDialog(context, 'Email already exist');
                } on InvalidEmailAuthException {
                  await showErrorDialog(context, 'Invalid email ');
                } on GenericAuthException {
                  await showErrorDialog(context, 'Failed to register');
                }
              },
              child: const Text('Register')),
          TextButton(
              onPressed: () => Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false),
              child: const Text('Already registered ?Login here'))
        ],
      ),
    );
  }
}
