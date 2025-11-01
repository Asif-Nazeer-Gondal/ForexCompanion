// Path: lib/features/home/widgets/rate_card.dart

import 'package:flutter/material.dart';
import '../../../models/forex_rate.dart'; // FIXED: Use the correct relative path

class RateCard extends StatelessWidget {
  final ForexRate rate;

  const RateCard({super.key, required this.rate});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        // These lines are correct, the error is in the ForexRate class itself
        title: Text('Rate: ${rate.rate.toStringAsFixed(2)}'),
        subtitle: Text('Date: ${rate.date.toLocal()}'),
      ),
    );
  }
}
