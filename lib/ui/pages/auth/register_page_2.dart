import 'package:flutter/material.dart';
import 'register_page_email.dart'; // Import the email registration page
import 'register_page_sms.dart'; // Import the SMS registration page

class RegisterPage2 extends StatelessWidget {
  const RegisterPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Add background image
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.3,
            image: AssetImage('lib/assets/images/hero_banner.png'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Choose Login Method',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildEmailButton(context), // Use custom button method
                  const SizedBox(height: 16),
                  _buildSmsButton(context), // Use custom button method
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Custom method for email button
  SizedBox _buildEmailButton(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Make button wider
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RegisterPageEmail(),
            ),
          );
        },
        icon: const Icon(Icons.email), // Add email icon
        label: const Text('Email'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFED50A),
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }

  // Custom method for SMS button
  SizedBox _buildSmsButton(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Make button wider
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RegisterPageSMS(),
            ),
          );
        },
        icon: const Icon(Icons.sms), // Add SMS icon
        label: const Text('SMS'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFED50A),
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }
}