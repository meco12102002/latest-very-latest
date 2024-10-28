import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RecommendedHaircutsScreen extends StatefulWidget {
  const RecommendedHaircutsScreen({super.key});

  @override
  _RecommendedHaircutsScreenState createState() => _RecommendedHaircutsScreenState();
}

class _RecommendedHaircutsScreenState extends State<RecommendedHaircutsScreen> {
  List<Map<dynamic, dynamic>> recommendedHaircuts = [];

  @override
  void initState() {
    super.initState();
    _fetchRecommendedHaircuts();
  }

  Future<void> _fetchRecommendedHaircuts() async {
    try {
      DatabaseEvent event = await FirebaseDatabase.instance.ref('haircuts').once();
      final haircutData = event.snapshot.value as Map<dynamic, dynamic>?;

      if (haircutData != null) {
        setState(() {
          recommendedHaircuts = haircutData.entries.map((entry) {
            return entry.value as Map<dynamic, dynamic>;
          }).toList();
        });
      } else {
        setState(() {
          recommendedHaircuts = []; // No haircuts found
        });
      }
    } catch (e) {
      // Handle any errors
      print("Error fetching recommended haircuts: $e");
      setState(() {
        recommendedHaircuts = []; // Clear the list on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Haircuts'),
      ),
      body: recommendedHaircuts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: recommendedHaircuts.length,
        itemBuilder: (context, index) {
          final haircut = recommendedHaircuts[index];
          final rating = haircut['rating']?.toString() ?? 'N/A'; // Retrieve the rating

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    haircut['image'] ?? 'https://via.placeholder.com/150',
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error, color: Colors.red),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        haircut['name'] ?? 'Unknown Haircut',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Price: ₱${haircut['price']?.toString() ?? 'N/A'}',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            rating,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
