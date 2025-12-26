import 'package:flutter/material.dart';
import '../domain/services/correlation_service.dart';

class CorrelationMatrixScreen extends StatefulWidget {
  const CorrelationMatrixScreen({super.key});

  @override
  State<CorrelationMatrixScreen> createState() => _CorrelationMatrixScreenState();
}

class _CorrelationMatrixScreenState extends State<CorrelationMatrixScreen> {
  final CorrelationService _service = CorrelationService();
  late List<String> _pairs;

  @override
  void initState() {
    super.initState();
    _pairs = _service.pairs;
  }

  Color _getColor(double value) {
    if (value == 1.0) return Colors.grey.shade400; // Self correlation
    if (value >= 0.8) return Colors.green.shade700; // Strong Positive
    if (value >= 0.5) return Colors.green.shade400; // Moderate Positive
    if (value <= -0.8) return Colors.red.shade700; // Strong Negative
    if (value <= -0.5) return Colors.red.shade400; // Moderate Negative
    return Colors.grey.shade300; // Weak/None
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Correlation Matrix'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Currency Correlations (Daily)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Green: Positive Correlation (Move together)\nRed: Negative Correlation (Move opposite)',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DataTable(
                  columnSpacing: 12,
                  headingRowColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.surfaceContainerHighest),
                  columns: [
                    const DataColumn(label: Text('')),
                    ..._pairs.map((pair) => DataColumn(
                          label: Text(
                            pair.replaceAll('/', '\n'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        )),
                  ],
                  rows: _pairs.map((rowPair) {
                    return DataRow(
                      cells: [
                        DataCell(Text(
                          rowPair,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        )),
                        ..._pairs.map((colPair) {
                          final value = _service.getCorrelation(rowPair, colPair);
                          return DataCell(
                            Container(
                              width: 50,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _getColor(value),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                value.toStringAsFixed(2),
                                style: TextStyle(
                                  color: value.abs() > 0.5 || value == 1.0
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}