import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:styles/helpers/helper_functions.dart';
import 'package:styles/ui/components/my_button.dart';
import 'package:styles/ui/components/text_field.dart'; // Ensure this path is correct
import 'package:styles/ui/pages/views/dashboard.dart'; // Import the Dashboard page

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Password visibility toggle
  bool _isPasswordVisible = false;

  // Login method
  void login() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (context.mounted) {
        Navigator.pop(context); // Close the loading dialog
        // Navigate to the Dashboard page after successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()), // Replace with your Dashboard widget
        );
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Close the loading dialog
      displayMessageToUser(e.code, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fetching the current theme context
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background, // Use background color from color scheme
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20), // Padding for the entire column
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Icon(
                Icons.cut,
                size: 80,
                color: colorScheme.primary, // Use primary color from color scheme
              ),
              const SizedBox(height: 25),

              // App name
              Text(
                "S T Y L E S",
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              // Email field with padding
              Padding(
                padding: const EdgeInsets.only(bottom: 25.0), // Spacing between fields
                child: SizedBox(
                  width: double.infinity, // Ensures full-width
                  child: MyTextField(
                    hintText: "Email",
                    obscureText: false,
                    controller: emailController,
                    // Removed the prefix icon
                  ),
                ),
              ),

              // Password field with padding
              Padding(
                padding: const EdgeInsets.only(bottom: 25.0), // Spacing between fields
                child: SizedBox(
                  width: double.infinity, // Ensures full-width
                  child: MyTextField(
                    hintText: "Password",
                    obscureText: !_isPasswordVisible, // Use the toggle for visibility
                    controller: passwordController,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: colorScheme.onSurface,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible; // Toggle password visibility
                        });
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 4),
              // Forgot password text
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Forgot password?",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface, // Ensures good visibility
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Login button
              MyButton(
                text: "Login",
                onTap: login,
              ),
              const SizedBox(height: 15),

              // Sign-up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account yet?",
                    style: TextStyle(color: colorScheme.onSurface), // Adjust for theme
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.onTap?.call(); // Call the onTap function to toggle registration
                    },
                    child: Text(
                      " Register here",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary, // Use primary color for register link
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
