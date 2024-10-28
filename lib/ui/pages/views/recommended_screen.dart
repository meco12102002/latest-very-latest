import 'package:flutter/material.dart';
import 'recommended_haircuts_screen.dart';

const List<Map<String, String>> faceShapes = [
  {
    'name': 'Oval',
    'image': 'lib/assets/images/oval_men.png',
  },
  {
    'name': 'Square',
    'image': 'lib/assets/images/square_men.png',
  },
  {
    'name': 'Round',
    'image': 'lib/assets/images/round_men.png',
  },
  {
    'name': 'Heart',
    'image': 'lib/assets/images/heart_men.png',
  },
];

const List<Map<String, String>> hairTypes = [
  {
    'name': 'Straight',
    'image': 'lib/assets/images/straight_men.png',
  },
  {
    'name': 'Wavy',
    'image': 'lib/assets/images/wavy_men.png',
  },
  {
    'name': 'Curly',
    'image': 'lib/assets/images/curly_men.png',
  },
  {
    'name': 'Coily',
    'image': 'lib/assets/images/coily_men.png',
  },
];

class RecommendationScreen extends StatefulWidget {
  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  String? selectedFaceShape;
  String? selectedHairType;
  bool isSummaryExpanded = false;

  void _getRecommendations() {
    if (selectedFaceShape != null && selectedHairType != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RecommendedHaircutsScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Style'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Your Face Shape',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: faceShapes.map((shape) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFaceShape = shape['name'];
                    });
                  },
                  child: Card(
                    color: selectedFaceShape == shape['name']
                        ? Colors.yellow[700]
                        : Colors.white,
                    elevation: 2,
                    child: Column(
                      children: [
                        Image.asset(shape['image']!, height: 100, width: 100),
                        const SizedBox(height: 5),
                        Text(shape['name']!, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Your Hair Type',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: hairTypes.map((type) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedHairType = type['name'];
                    });
                  },
                  child: Card(
                    color: selectedHairType == type['name']
                        ? Colors.yellow[700]
                        : Colors.white,
                    elevation: 2,
                    child: Column(
                      children: [
                        Image.asset(type['image']!, height: 100, width: 100),
                        const SizedBox(height: 5),
                        Text(type['name']!, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Collapsible section for summary
            ExpansionTile(
              title: const Text(
                'My Hair and Face Shape Summary',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              initiallyExpanded: isSummaryExpanded,
              onExpansionChanged: (bool expanded) {
                setState(() {
                  isSummaryExpanded = expanded;
                });
              },
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Face Shape: ${selectedFaceShape ?? "None"}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Hair Type: ${selectedHairType ?? "None"}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _getRecommendations,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow[700],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 12.0,
                          ),
                        ),
                        child: const Text('Get Your Recommendation'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
