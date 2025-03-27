import 'package:flutter/material.dart';

class RewardProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Your Recycling Progress", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        LinearProgressIndicator(
          value: 0.6,  // Assume user has recycled 60% of target
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
        SizedBox(height: 5),
        Text("You've recycled 60kg of E-Waste! 🎉", style: TextStyle(color: Colors.green)),
      ],
    );
  }
}
