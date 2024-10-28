import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:styles/auth/auth.dart';
import 'package:styles/theme/dark.dart';
import 'package:styles/theme/light.dart';
import 'package:styles/ui/pages/auth/login_register.dart';
import 'package:styles/ui/pages/views/ar_home_page.dart';
import 'package:styles/ui/pages/views/bookings.dart';
import 'package:styles/ui/pages/views/dashboard.dart';
import 'package:styles/ui/pages/views/home.dart';
import 'package:styles/ui/pages/views/notifications.dart';
import 'package:styles/ui/pages/views/profile.dart';
import 'package:styles/ui/pages/views/recommended_haircuts_screen.dart';
import 'package:styles/ui/pages/views/recommended_screen.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(), // Ensure this widget is defined
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: ThemeMode.system,
      routes: {
        '/login-register':(context) => const LoginOrRegister(),
        '/home-page':(context)=> const Dashboard(),
        '/home': (context)=>  const Home(),
        '/notification':(context)=> const Notifications(),
        '/profile': (context)=> const ProfilePage(),
        '/recommended-screen': (context)=> RecommendationScreen(),
        '/bookings': (context)=> const Bookings(),
        '/ar-home': (context)=> const HomePage(),
        '/recommended-haircuts-screen': (context)=> const RecommendedHaircutsScreen(),

      },

    );
  }
}
