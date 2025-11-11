// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_tool_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionToolModel _$TransactionToolModelFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['amount', 'description', 'category', 'is_expense'],
  );
  return TransactionToolModel(
    amount: (json['amount'] as num).toDouble(),
    description: json['description'] as String,
    category: json['category'] as String,
    isExpense: json['is_expense'] as bool,
  );
}

Map<String, dynamic> _$TransactionToolModelToJson(
        TransactionToolModel instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'description': instance.description,
      'category': instance.category,
      'is_expense': instance.isExpense,
    };
