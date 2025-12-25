// lib/features/tools/presentation/correlation_matrix_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../state/providers/correlation_provider.dart';

class CorrelationMatrixScreen extends ConsumerWidget {
  const CorrelationMatrixScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matrixAsync = ref.watch(correlationMatrixProvider);
    final pairs = ref.watch(correlationPairsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Correlation Matrix'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(correlationMatrixProvider),
          ),
        ],
      ),
      body: matrixAsync.when(
        data: (matrix) {
          if (matrix.isEmpty) {
            return const Center(child: Text('No data available'));
          }
          
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20,
                columns: [
                  const DataColumn(label: Text('')), // Corner cell
                  ...pairs.map((p) => DataColumn(
                    label: Text(
                      p.replaceAll('/', ''), // Shorten name
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),
                ],
                rows: pairs.map((rowPair) {
                  return DataRow(
                    cells: [
                      DataCell(Text(
                        rowPair.replaceAll('/', ''),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )),
                      ...pairs.map((colPair) {
                        final value = matrix[rowPair]?[colPair] ?? 0.0;
                        return DataCell(
                          Container(
                            alignment: Alignment.center,
                            width: 50,
                            height: 30,
                            decoration: BoxDecoration(
                              color: _getColorForCorrelation(value),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              value.toStringAsFixed(2),
                              style: TextStyle(
                                color: value.abs() > 0.5 ? Colors.white : Colors.black,
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
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Color _getColorForCorrelation(double value) {
    if (value > 0) {
      return Colors.green.withOpacity((value.abs() * 0.8) + 0.2);
    } else if (value < 0) {
      return Colors.red.withOpacity((value.abs() * 0.8) + 0.2);
    } else {
      return Colors.grey.withOpacity(0.2);
    }
  }
}