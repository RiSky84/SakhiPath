import 'package:flutter/material.dart';

class GoogleFeaturesScreen extends StatelessWidget {
  const GoogleFeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Features'),
        backgroundColor: const Color(0xFF6B4EFF),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'Google Features Coming Soon\n\nThis feature will include:\n• Google Sign-In\n• Maps Integration\n• Cloud Storage\n\nStay tuned!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
