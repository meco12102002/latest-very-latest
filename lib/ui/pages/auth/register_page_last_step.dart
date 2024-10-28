import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:styles/helpers/helper_functions.dart';
import 'package:styles/ui/components/my_button.dart';
import '../../components/text_field.dart';
import '../views/dashboard.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap; // Callback for switching to the Sign In page

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

// Firebase Authentication instance
final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseDatabase _database = FirebaseDatabase.instance;

class _RegisterPageState extends State<RegisterPage> {
  // Controllers for input fields
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Phone number variables
  String initialCountry = 'PH'; // Initial country code
  PhoneNumber number = PhoneNumber(isoCode: 'PH'); // Default phone number
  bool isPasswordObscured = true; // For toggling password visibility
  bool isConfirmPasswordObscured = true; // For toggling confirm password visibility

  // Firebase Database reference
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref("users");

  // Method for handling user registration
  // Method for handling user registration
  void register() async {
    // Show loading indicator
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Check if the passwords match
    if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
      Navigator.pop(context); // Close loading indicator
      displayMessageToUser("Passwords don't match", context);
      return; // Exit function if passwords don't match
    }

    // Validate email and password
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.length < 6) {
      Navigator.pop(context); // Close loading indicator
      displayMessageToUser("Please enter a valid email and password.", context);
      return;
    }

    try {
      // Create user account using email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Safely get the user ID, ensuring it's non-null
      String userId = userCredential.user?.uid ?? '';

      // Check if userId is not empty
      if (userId.isNotEmpty) {
        // Write to Firebase Database under the user's ID
        await databaseReference.child(userId).set({
          'fullName': fullNameController.text.trim(),
          'phone': number.phoneNumber,
          'email': email, // Optionally, store the email as well
        });

        Navigator.pop(context); // Close loading indicator

        // Navigate to Dashboard after successful registration
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
      } else {
        Navigator.pop(context); // Close loading indicator
        displayMessageToUser("User ID is null", context); // Handle case where user ID is null
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Close loading indicator
      print(e); // Print error for debugging
      _handleAuthError(e); // Handle authentication error
    } catch (error) {
      Navigator.pop(context); // Close loading indicator
      print(error); // Print error for debugging
      displayMessageToUser("An error occurred while saving user data.", context);
    }
  }


  // Method for handling Firebase authentication errors
  void _handleAuthError(FirebaseAuthException e) {
    String errorMessage;

    // Determine the error message based on the error code
    switch (e.code) {
      case 'email-already-in-use':
        errorMessage = "The email is already in use.";
        break;
      case 'invalid-email':
        errorMessage = "The email address is not valid.";
        break;
      case 'weak-password':
        errorMessage = "The password provided is too weak.";
        break;
      default:
        errorMessage = "An unknown error occurred.";
    }

    displayMessageToUser(errorMessage, context); // Display error message to user
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context); // Get current theme

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.cut, // Icon for the application
                  size: 80,
                  color: theme.primaryColor,
                ),
                const SizedBox(height: 25),
                Text(
                  "S T Y L E S",
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),

                // Full Name field
                Padding(
                  padding: const EdgeInsets.only(bottom: 25.0),
                  child: MyTextField(
                    hintText: "Full Name",
                    controller: fullNameController,
                    obscureText: false,
                  ),
                ),

                // Phone Number field with country code picker
                Padding(
                  padding: const EdgeInsets.only(bottom: 25.0),
                  child: InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      this.number = number; // Update phone number
                    },
                    initialValue: number, // Set initial value
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.DROPDOWN,
                    ),
                    inputDecoration: const InputDecoration(
                      hintText: "Phone Number",
                      border: OutlineInputBorder(),
                    ),
                    inputBorder: const OutlineInputBorder(),
                    maxLength: 12, // Set maximum length for phone number
                  ),
                ),

                // Email field
                Padding(
                  padding: const EdgeInsets.only(bottom: 25.0),
                  child: MyTextField(
                    hintText: "Email",
                    controller: emailController,
                    obscureText: false,
                  ),
                ),

                // Password field
                Padding(
                  padding: const EdgeInsets.only(bottom: 25.0),
                  child: MyTextField(
                    hintText: "Password",
                    controller: passwordController,
                    obscureText: isPasswordObscured,
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordObscured ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordObscured = !isPasswordObscured; // Toggle password visibility
                        });
                      },
                    ),
                  ),
                ),

                // Confirm Password field
                Padding(
                  padding: const EdgeInsets.only(bottom: 25.0),
                  child: MyTextField(
                    hintText: "Confirm Password",
                    controller: confirmPasswordController,
                    obscureText: isConfirmPasswordObscured,
                    suffixIcon: IconButton(
                      icon: Icon(
                        isConfirmPasswordObscured ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isConfirmPasswordObscured = !isConfirmPasswordObscured; // Toggle confirm password visibility
                        });
                      },
                    ),
                  ),
                ),

                // Register Button
                MyButton(onTap: register, text: 'Register'),

                // Sign In option
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    GestureDetector(
                      onTap: widget.onTap, // Call onTap to switch to Sign In
                      child: const Text(
                        " Sign In",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
