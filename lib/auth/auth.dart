import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:styles/ui/pages/auth/login_register.dart';
import 'package:styles/ui/pages/views/dashboard.dart';
import 'package:styles/ui/pages/views/home.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const Dashboard();
          } else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
