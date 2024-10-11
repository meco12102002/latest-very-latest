import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BarberDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
        title: Text('Thursday, August 24', // Placeholder for date
            style: TextStyle(color: Colors.white, fontSize: 12)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'HEY,', // Placeholder for user's greeting
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  Text(
                    'MICHAEL', // Placeholder for user's name
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Search Bar
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[850],
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.white54),
                  prefixIcon: Icon(Icons.search, color: Colors.yellow),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Latest Visit
              Text('Latest Visit', style: TextStyle(color: Colors.white, fontSize: 16)),
              Card(
                color: Colors.grey[900],
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/placeholder.jpg'), // Placeholder for image
                  ),
                  title: Text('Richard Anderson', style: TextStyle(color: Colors.white)), // Placeholder for name
                  subtitle: Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow, size: 16),
                      Text('4.9', style: TextStyle(color: Colors.white)), // Placeholder for rating
                      Text(' • 114 reviews', style: TextStyle(color: Colors.white54)), // Placeholder for reviews
                    ],
                  ),
                  trailing: Text('PRO', style: TextStyle(color: Colors.yellow)),
                ),
              ),
              SizedBox(height: 20),

              // Nearby Barbershops
              Text('Nearby Barbershops', style: TextStyle(color: Colors.white, fontSize: 16)),
              Container(
                height: 150,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('barbershops').snapshots(), // Placeholder collection
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator(); // Loading indicator
                    var barbershops = snapshot.data!.docs;

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: barbershops.length,
                      itemBuilder: (context, index) {
                        var shop = barbershops[index];
                        return Card(
                          color: Colors.grey[900],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/placeholder.jpg', // Placeholder for image
                                height: 100,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.yellow, size: 16),
                                    Text('4.8', // Placeholder for rating
                                        style: TextStyle(color: Colors.white)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 20),

              // Haircuts Section
              Text('Available Haircuts', style: TextStyle(color: Colors.white, fontSize: 16)),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('haircuts').snapshots(), // Placeholder collection
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator(); // Loading indicator
                  var haircuts = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: haircuts.length,
                    itemBuilder: (context, index) {
                      var haircut = haircuts[index];
                      return Card(
                        color: Colors.grey[900],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Haircut label
                              Text(
                                haircut['label'] ?? 'Classic Haircut', // Placeholder for haircut label
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                              SizedBox(height: 5),
                              // Price
                              Text(
                                '₱${haircut['price'] ?? 500}', // Placeholder for price
                                style: TextStyle(color: Colors.yellow, fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              // Tags (Face shapes)
                              Wrap(
                                spacing: 6.0,
                                children: (haircut['tags'] ?? ['Round', 'Oval']).map<Widget>((tag) {
                                  return Chip(
                                    label: Text(tag),
                                    backgroundColor: Colors.grey[800],
                                    labelStyle: TextStyle(color: Colors.white),
                                  );
                                }).toList(),
                              ),
                              SizedBox(height: 5),
                              // Virtual Try-On Button
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.black, backgroundColor: Colors.yellow, // Text color
                                  ),
                                  onPressed: () {
                                    // Add functionality for virtual try-on here
                                  },
                                  child: Text('Virtual Try On'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
