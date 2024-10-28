import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:styles/ui/pages/views/recommended_haircuts_screen.dart';
import 'package:styles/ui/pages/views/recommended_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late PageController _servicePageController;
  late PageController _haircutPageController;
  Timer? _timer;
  int _currentServicePage = 0;
  int _currentHaircutPage = 0;
  List<Map<dynamic, dynamic>> serviceList = [];
  List<Map<dynamic, dynamic>> haircutList = [];
  String _fullName = ""; // Variable to store the full name


  @override
  void initState() {
    super.initState();
    _servicePageController = PageController();
    _haircutPageController = PageController();
    _startAutoScroll();
    _fetchServices();
    _fetchUserName(); // Fetch the user's full name here
    _fetchHaircuts();
  }

  void _fetchUserName() async {
    // Get the current user ID
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch the user's details from the database
      DatabaseEvent event = await FirebaseDatabase.instance.ref('users/${user.uid}').once();
      final userData = event.snapshot.value as Map<dynamic, dynamic>?;

      if (userData != null) {
        setState(() {
          // Extract the full name from the user data
          _fullName = userData['fullName'] ?? "Customer"; // Default name
        });
      }
    }
  }

  void _fetchServices() async {
    DatabaseEvent event = await FirebaseDatabase.instance.ref('services').once();
    final serviceData = event.snapshot.value as Map<dynamic, dynamic>?;

    if (serviceData != null) {
      setState(() {
        serviceList = serviceData.entries.map((e) {
          return e.value as Map<dynamic, dynamic>;
        }).toList();
      });
    }
  }

  void _fetchHaircuts() async {
    DatabaseEvent event = await FirebaseDatabase.instance.ref().child('haircuts').once();
    final haircutData = event.snapshot.value as Map<dynamic, dynamic>?;

    if (haircutData != null) {
      setState(() {
        haircutList = haircutData.entries.map((e) {
          return e.value as Map<dynamic, dynamic>;
        }).toList();
      });
    }
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_servicePageController.hasClients) {
        if (_currentServicePage >= serviceList.length - 1) {
          _currentServicePage = 0;
        } else {
          _currentServicePage++;
        }
        _servicePageController.animateToPage(
          _currentServicePage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _servicePageController.dispose();
    _haircutPageController.dispose();
    super.dispose();
  }

  void _scanFaceShape() {
    // Implement your face shape scanning functionality here
    print("Scanning face shape...");
  }

  void _recommendHaircuts() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  RecommendationScreen()
      ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Styles App'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${_fullName.isNotEmpty ? _fullName : "Customer"}!',
              style: TextStyle(
                fontSize: 24,
                color: isLightMode ? Colors.black : Colors.white, // Set text color based on theme
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'OUR SERVICES',
              style: TextStyle(
                fontSize: 18,
                color: isLightMode ? Colors.black : Colors.white, // Set text color based on theme
              ),
            ),
            const SizedBox(height: 10),
            // Services Horizontal Scroll
            SizedBox(
              height: 150,
              child: serviceList.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _servicePageController,
                      itemCount: serviceList.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentServicePage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        var service = serviceList[index];
                        return Card(
                          color: Theme.of(context).cardColor,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  service['image'] ?? 'https://via.placeholder.com/150',
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error, color: Colors.red),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  color: Colors.black54,
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    service['name'] ?? 'Unknown Service',
                                    style: TextStyle(
                                      color: isLightMode ? Colors.black : Colors.white, // Set text color based on theme
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 40,
                                left: 0,
                                right: 0,
                                child: Wrap(
                                  spacing: 6.0,
                                  alignment: WrapAlignment.center,
                                  children: (service['tags'] as List<dynamic>? ?? [])
                                      .map((tag) => Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.yellow.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      tag.toString(),
                                      style: const TextStyle(color: Colors.black),
                                    ),
                                  ))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Page Indicator
                  SmoothPageIndicator(
                    controller: _servicePageController,
                    count: serviceList.length,
                    effect: const WormEffect(
                      activeDotColor: Colors.yellow,
                      dotColor: Colors.grey,
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'HAIRCUTS FOR YOU',
              style: TextStyle(
                fontSize: 18,
                color: isLightMode ? Colors.black : Colors.white, // Set text color based on theme
              ),
            ),
            const SizedBox(height: 10),
            // Haircuts Horizontal Scroll
            SizedBox(
              height: 150,
              child: haircutList.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _haircutPageController,
                      itemCount: haircutList.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentHaircutPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        var haircut = haircutList[index];
                        return Card(
                          color: Theme.of(context).cardColor,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    haircut['image'] ?? 'https://via.placeholder.com/100',
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.error, color: Colors.red),
                                  ),
                                ),
                                Positioned(
                                  left: 100,
                                  right: 0,
                                  top: 10,
                                  child: Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          haircut['name'] ?? 'Unknown Haircut',
                                          style: TextStyle(
                                            color: isLightMode ? Colors.black : Colors.white, // Set text color based on theme
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          '₱${haircut['price']?.toString() ?? 'N/A'}',
                                          style: const TextStyle(
                                              color: Colors.yellow, fontSize: 12),
                                        ),
                                        const SizedBox(height: 5),
                                        // Star Rating Display
                                        Row(
                                          children: List.generate(
                                            5,
                                                (index) {
                                              return Icon(
                                                index < (haircut['rating'] ?? 0)
                                                    ? Icons.star
                                                    : Icons.star_border,
                                                color: Colors.yellow,
                                                size: 16,
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        // Displaying Tags
                                        Wrap(
                                          spacing: 6.0,
                                          children: (haircut['tags'] as List<dynamic>? ?? [])
                                              .map((tag) => Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.yellow.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              tag.toString(),
                                              style: const TextStyle(color: Colors.black),
                                            ),
                                          ))
                                              .toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Page Indicator
                  SmoothPageIndicator(
                    controller: _haircutPageController,
                    count: haircutList.length,
                    effect: const WormEffect(
                      activeDotColor: Colors.yellow,
                      dotColor: Colors.grey,
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: FloatingActionButton(
              onPressed: _scanFaceShape,
              child: const Icon(Icons.face),
              backgroundColor: const Color(0xFFFED50A),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 80, // Adjust this value to position the second FAB
            child: FloatingActionButton(
              onPressed: _recommendHaircuts,
              child: const Icon(Icons.recommend),
              backgroundColor: const Color(0xFFFED50A),
            ),
          ),
        ],
      ),
    );
  }

}
