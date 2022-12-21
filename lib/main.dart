import 'package:flutter/material.dart';
import 'package:notesapp_learning/constants/routes.dart';
import 'package:notesapp_learning/services/auth/auth_service.dart';
import 'package:notesapp_learning/views/login_page.dart';
import 'package:notesapp_learning/views/notes_view.dart';
import 'package:notesapp_learning/views/register.dart';
import 'package:notesapp_learning/views/verify_email.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.firebase().initialize();
  runApp(MaterialApp(
    home: const MyHomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      notesRoute:(context) => const NotesView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
    },
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
  ));
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
               // print('Email is verified');
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
