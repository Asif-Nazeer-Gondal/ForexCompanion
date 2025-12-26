import 'package:flutter/material.dart';
import 'package:forex_companion/features/tools/domain/services/currency_converter_service.dart';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final TextEditingController _amountController = TextEditingController();
  final CurrencyConverterService _converterService = CurrencyConverterService();
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  double _result = 0.0;

  @override
  void initState() {
    super.initState();
    _amountController.text = '1';
    _convert();
  }

  void _convert() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final converted = _converterService.convert(amount, _fromCurrency, _toCurrency);

    setState(() {
      _result = converted;
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => _convert(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _fromCurrency,
                            decoration: const InputDecoration(labelText: 'From'),
                            items: _converterService.availableCurrencies.map((String currency) {
                              return DropdownMenuItem<String>(
                                value: currency,
                                child: Text(currency),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _fromCurrency = newValue!;
                                _convert();
                              });
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Icon(Icons.arrow_forward),
                        ),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _toCurrency,
                            decoration: const InputDecoration(labelText: 'To'),
                            items: _converterService.availableCurrencies.map((String currency) {
                              return DropdownMenuItem<String>(
                                value: currency,
                                child: Text(currency),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _toCurrency = newValue!;
                                _convert();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Result',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '${_result.toStringAsFixed(2)} $_toCurrency',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}