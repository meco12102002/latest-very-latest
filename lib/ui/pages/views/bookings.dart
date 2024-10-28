import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Barber {
  final String name;
  final String profileImage;
  final double rating;

  Barber({required this.name, required this.profileImage, required this.rating});
}

class Bookings extends StatefulWidget {
  const Bookings({super.key});

  @override
  _BookingsState createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  Barber? selectedBarber;
  List<String> selectedServices = [];
  bool termsAccepted = false;
  bool hasAppointment = false;
  String specialRequest = ''; // Store the user's special request

  List<Barber> barbers = [];

  final Map<String, int> services = {
    'Haircut': 250,
    'Shave': 150,
    'Beard Trim': 150,
    'Hair Wash': 150,
    'Hair Coloring': 300
  };

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _checkUserAppointment();
    _fetchBarbers();
  }

  Future<void> _fetchBarbers() async {
    final barbersRef = _database.ref('barbers');
    final snapshot = await barbersRef.once();

    if (snapshot.snapshot.exists) {
      final barbersData = snapshot.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        barbers = barbersData.entries.map((entry) {
          final data = entry.value;
          return Barber(
            name: data['name'] as String,
            profileImage: data['profileImage'] as String,
            rating: (data['rating'] as num).toDouble(),
          );
        }).toList();
      });
    }
  }

  Future<void> _checkUserAppointment() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userId = user.uid;
      hasAppointment = await checkIfAlreadyAppointed(userId);
      setState(() {});
    }
  }

  Future<bool> checkIfAlreadyAppointed(String userId) async {
    final appointmentsRef = _database.ref('appointments/$userId');
    final snapshot = await appointmentsRef.once();

    if (snapshot.snapshot.exists) {
      final appointments = snapshot.snapshot.value as Map<dynamic, dynamic>;
      for (var appointment in appointments.values) {
        if (appointment['isAppointed'] == true) {
          return true;
        }
      }
    }
    return false;
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime initialDate = DateTime.now().add(const Duration(days: 2));
    final DateTime lastDate = DateTime.now().add(const Duration(days: 365));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate,
      lastDate: lastDate,
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> pickTime(BuildContext context) async {
    final TimeOfDay initialTime = TimeOfDay.now();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      if ((picked.hour > 9 || (picked.hour == 9 && picked.minute == 0)) &&
          (picked.hour < 21 || (picked.hour == 21 && picked.minute == 0))) {
        setState(() {
          selectedTime = picked;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a time between 9 AM and 9 PM.')),
        );
      }
    }
  }

  void toggleService(String service) {
    setState(() {
      if (selectedServices.contains(service)) {
        selectedServices.remove(service);
      } else {
        selectedServices.add(service);
      }
    });
  }

  int calculateTotalCost() {
    return selectedServices.fold(0, (sum, service) => sum + (services[service] ?? 0));
  }

  Future<void> saveAppointment(String userId) async {
    if (selectedDate != null && selectedTime != null && selectedBarber != null) {
      final appointmentRef = _database.ref('appointments/$userId').push();
      await appointmentRef.set({
        'date': '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
        'time': selectedTime!.format(context),
        'barber': selectedBarber!.name,
        'services': selectedServices,
        'totalCost': calculateTotalCost(),
        'isAppointed': false,
        'status': "pending",
        'specialRequest': specialRequest, // Save special request
      });
    }
  }

  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Your Booking'),
          content: const Text('Are you sure you want to confirm your booking?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () async {
                if (termsAccepted) {
                  final user = _auth.currentUser;
                  if (user != null) {
                    final userId = user.uid;
                    final hasAppointment = await checkIfAlreadyAppointed(userId);
                    if (!hasAppointment) {
                      await saveAppointment(userId);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Appointment set!')),
                      );
                      Navigator.of(context).pop();
                      _checkUserAppointment();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('You already have an appointment.')),
                      );
                    }
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please accept the terms and conditions.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkTheme ? Colors.black : Colors.white;
    final textColor = isDarkTheme ? Colors.white : Colors.black;
    final accentColor = isDarkTheme ? Colors.amber : Colors.amber[600];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Book a Service'),
        backgroundColor: accentColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Special Request TextField
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Special Request',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            specialRequest = value;
                          });
                        },
                      ),
                    ),

                    // Terms and Conditions Checkbox
                    Row(
                      children: [
                        Checkbox(
                          value: termsAccepted,
                          onChanged: (value) {
                            setState(() {
                              termsAccepted = value ?? false;
                            });
                          },
                        ),
                        const Expanded(
                          child: Text('I accept the terms and conditions'),
                        ),
                      ],
                    ),

                    // Total Cost
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Total Cost: ₱${calculateTotalCost()}',
                        style: TextStyle(color: accentColor, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),

                    // Confirm Booking or Already Appointed Button
                    ElevatedButton(
                      onPressed: hasAppointment
                          ? null
                          : () {
                        showConfirmationDialog(context);
                      },
                      child: Text(hasAppointment
                          ? 'You have already set an appointment'
                          : 'Book Appointment'),
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
