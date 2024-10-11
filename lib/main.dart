import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:styles/ui/pages/auth/login_email_gmail_otp.dart';
import 'package:styles/ui/pages/auth/login_page.dart';
import 'package:styles/ui/pages/auth/otp_verification.dart';
import 'package:styles/ui/pages/auth/register_page_1.dart';
import 'package:styles/ui/pages/auth/register_page_2.dart';
import 'package:styles/ui/pages/auth/register_page_email.dart';
import 'package:styles/ui/pages/auth/register_page_sms.dart';
import 'package:styles/ui/pages/customers/home.dart';
import 'ui/pages/get_started_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barber App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/otp_verification') {
          final args = settings.arguments as Map<String, dynamic>?;
          final userEmailOrPhone = args?['userEmailOrPhone'] as String?;
          final isEmailLogin = args?['isEmailLogin'] as bool?;

          return MaterialPageRoute(
            builder: (context) => OtpPage(
              userEmailOrPhone: userEmailOrPhone ?? '',
              isEmailLogin: isEmailLogin ?? true,
            ),
          );
        }

        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => GetStartedPage());
          case '/login':
            return MaterialPageRoute(builder: (context) => const LoginPage());
          case '/register':
            return MaterialPageRoute(builder: (context) => const RegisterPage1());
          case '/register/step2': // Route for RegisterPage2
            return MaterialPageRoute(builder: (context) => const RegisterPage2());
          case '/register/email': // Route for RegisterPageEmail
            return MaterialPageRoute(builder: (context) => const RegisterPageEmail());
          case '/register/sms': // Route for RegisterPageSMS
            return MaterialPageRoute(builder: (context) => const RegisterPageSMS());
          case '/home':
            return MaterialPageRoute(builder: (context) => BarberDashboard());
          case '/login-otp':
          // Get the email from the settings arguments
            final args = settings.arguments as Map<String, dynamic>?;
            final email = args?['email'] as String?;
            return MaterialPageRoute(builder: (context) => OtpVerificationPage(email: email ?? '')); // Provide a default value if email is null
          default:
            return null;
        }
      },
    );
  }
}