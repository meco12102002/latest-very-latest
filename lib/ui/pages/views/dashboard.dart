import 'package:flutter/material.dart';

import 'ar_home_page.dart';
import 'home.dart'; // Import the Home view
import 'bookings.dart'; // Import the Bookings view
import 'notifications.dart'; // Import the Notifications view
import 'profile.dart'; // Import the Profile view

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0; // For BottomNavigationBar

  // List of pages for navigation
  final List<Widget> _pages = [
    const Home(), // Home page displaying services and haircuts
    const Bookings(), // Bookings page
    const Notifications(), // Notifications page
    const ProfilePage(), // Profile page
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index to the tapped index
    });
  }

  @override
  Widget build(BuildContext context) {
    // Fetching the current theme context
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final Color floatingButtonColor = theme.colorScheme.secondary; // Theme color for the button

    return Scaffold(
      backgroundColor: backgroundColor,
      body: _pages[_selectedIndex], // Display the selected page
      floatingActionButton: Visibility(
        visible: _selectedIndex == 0, // Show only on the Home page
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: floatingButtonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1, // Responsive padding
              vertical: 12,
            ),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.face, color: Colors.black),
              SizedBox(height: 5),
              Text(
                'Get your style',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex, // Highlight the current index
        selectedItemColor: theme.primaryColor, // Color for selected item
        unselectedItemColor: theme.disabledColor, // Color for unselected items
        backgroundColor: backgroundColor, // Background color of the bar
        type: BottomNavigationBarType.fixed, // Ensure the items are fixed
        onTap: _onItemTapped, // Function to handle item taps
      ),
    );
  }
}
