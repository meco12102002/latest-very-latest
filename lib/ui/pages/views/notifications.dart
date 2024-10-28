import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final DatabaseReference _notificationsRef = FirebaseDatabase.instance.ref('notifications');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<dynamic, dynamic>> notificationsList = []; // To store notifications

  @override
  void initState() {
    super.initState();
    _checkAndCreateNotificationNode();
    _fetchNotifications(); // Fetch notifications when the widget initializes
  }

  Future<void> _checkAndCreateNotificationNode() async {
    // Get the current user
    User? user = _auth.currentUser;

    if (user != null) {
      String userId = user.uid; // Get the user ID

      // Check if the notifications node for the current user exists
      DatabaseEvent event = await _notificationsRef.child(userId).once();
      final notificationData = event.snapshot.value;

      if (notificationData == null) {
        // If the node does not exist, create it with an empty value
        await _notificationsRef.child(userId).set({
          'notifications': [], // Initialize with an empty list
        });
      }
    }
  }

  Future<void> _fetchNotifications() async {
    User? user = _auth.currentUser;

    if (user != null) {
      String userId = user.uid; // Get the user ID
      DatabaseEvent event = await _notificationsRef.child(userId).once();
      final notificationData = event.snapshot.value as Map<dynamic, dynamic>?;

      if (notificationData != null) {
        setState(() {
          // Convert notifications to a list of maps
          notificationsList = List<Map<dynamic, dynamic>>.from(notificationData['notifications'] ?? []);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.deepPurple, // Modern color for the app bar
      ),
      body: notificationsList.isEmpty
          ? const Center(
        child: Text(
          'No notifications',
          style: TextStyle(fontSize: 18, color: Colors.grey), // Grey color for no notifications message
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0), // Padding around the list
        itemCount: notificationsList.length,
        itemBuilder: (context, index) {
          final notification = notificationsList[index];
          final dateTime = notification['dateTime'] ?? 'Unknown Date';
          final content = notification['content'] ?? 'No Content';

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0), // Spacing between cards
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0), // Rounded corners
            ),
            elevation: 4, // Shadow effect for card
            child: Padding(
              padding: const EdgeInsets.all(16.0), // Padding inside the card
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Bold title
                  ),
                  const SizedBox(height: 8.0), // Space between title and date
                  Text(
                    dateTime,
                    style: const TextStyle(color: Colors.grey), // Grey date text
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
