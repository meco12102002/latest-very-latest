import 'package:flutter/material.dart';
import 'auth/login_register.dart'; // Ensure this import path is correct

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Opacity(
            opacity: 0.3,
            child: Image.asset(
              'lib/assets/images/hero_banner.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24), // Add horizontal padding
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Main Title
                  Text(
                    'Discover Your Perfect Style',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                    textAlign: TextAlign.center, // Center the text
                  ),
                  SizedBox(height: 16), // Space between title and subtitle

                  // Subtitle
                  Text(
                    'at Styles',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center, // Center the text
                  ),
                  SizedBox(height: 16), // Space between subtitle and description

                  // Description
                  Text(
                    'Haircut Recommendations, Virtual Try-on, and Seamless Service Booking',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Button in lower right corner
          Positioned(
            bottom: 16,
            right: 16,
            child: GestureDetector(
              onTap: () {
                // Navigate to the LoginOrRegister page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginOrRegister()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Increased padding for a larger button
                decoration: const BoxDecoration(
                  color: Color(0xFFFED50A),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.cut, color: Colors.black, size: 20), // Slightly larger icon
                    SizedBox(width: 8),
                    Text(
                      'Get Started',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18, // Increased font size for better visibility
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
