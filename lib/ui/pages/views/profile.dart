import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _profileImageUrl = 'https://via.placeholder.com/150'; // Placeholder for profile picture
  final ImagePicker _picker = ImagePicker();

  Future<Map<String, String>> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user.uid}');
      final DatabaseEvent event = await ref.once();
      final DataSnapshot snapshot = event.snapshot;
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        return {
          'fullName': data['fullName'] ?? 'No Name',
          'email': user.email ?? 'No Email',
          'profileImage': data['profileImage'] ?? _profileImageUrl,
        };
      }
    }
    return {
      'fullName': 'No Name',
      'email': 'No Email',
      'profileImage': _profileImageUrl,
    };
  }

  Future<void> _updateProfilePicture() async {
    final pickedFile = await showDialog<XFile?>(context: context, builder: (context) {
      return AlertDialog(
        title: const Text('Select Profile Picture'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  final image = await _picker.pickImage(source: ImageSource.camera);
                  Navigator.of(context).pop(image);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Gallery'),
                onTap: () async {
                  final image = await _picker.pickImage(source: ImageSource.gallery);
                  Navigator.of(context).pop(image);
                },
              ),
            ],
          ),
        ),
      );
    });

    if (pickedFile != null) {
      String filePath = 'profile_images/${FirebaseAuth.instance.currentUser!.uid}.jpg';
      File imageFile = File(pickedFile.path);
      try {
        final storageRef = FirebaseStorage.instance.ref(filePath);
        await storageRef.putFile(imageFile);
        String downloadUrl = await storageRef.getDownloadURL();

        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          DatabaseReference ref = FirebaseDatabase.instance.ref('users/${user.uid}');
          await ref.update({'profileImage': downloadUrl});
        }

        setState(() {
          _profileImageUrl = downloadUrl;
        });
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed('/settings');
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, String>>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data.'));
          } else if (snapshot.hasData) {
            final userData = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _updateProfilePicture,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(userData['profileImage'] ?? _profileImageUrl),
                      child: Icon(Icons.camera_alt, color: Colors.white, size: 30), // Camera icon overlay
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    userData['fullName'] ?? 'No Name',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userData['email'] ?? 'No Email',
                    style: const TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: () => _signOut(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Sign Out',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Additional Options',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  _buildOptionCard('Edit Profile', Icons.edit, '/edit_profile'),
                  _buildOptionCard('Change Password', Icons.lock, '/change_password'),
                ],
              ),
            );
          }
          return const Center(child: Text('No data available.'));
        },
      ),
    );
  }

  Widget _buildOptionCard(String title, IconData icon, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(route);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
