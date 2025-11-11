// lib/features/jarvis/domain/models/transaction_tool_model.dart

import 'package:json_annotation/json_annotation.dart';

part 'transaction_tool_model.g.dart'; // Required for code generation

/// A structured request model the AI must return when asked to log a transaction.
/// This allows the app to automatically populate the Budget input screen.
@JsonSerializable()
class TransactionToolModel {
  @JsonKey(name: 'amount', required: true)
  final double amount;

  @JsonKey(name: 'description', required: true)
  final String description;

  @JsonKey(name: 'category', required: true)
  final String category; // e.g., 'Food', 'Transport', 'Income'

  @JsonKey(name: 'is_expense', required: true)
  final bool isExpense;

  TransactionToolModel({
    required this.amount,
    required this.description,
    required this.category,
    required this.isExpense,
  });

  factory TransactionToolModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionToolModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToolModelToJson(this);
}