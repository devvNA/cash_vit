import 'package:uuid/uuid.dart';

enum ExpenseType { income, expense }

extension ExpenseTypeExtension on ExpenseType {
  String get displayName {
    return switch (this) {
      ExpenseType.income => 'Income',
      ExpenseType.expense => 'Expense',
    };
  }

  String get value {
    return switch (this) {
      ExpenseType.income => 'income',
      ExpenseType.expense => 'expense',
    };
  }

  static ExpenseType fromString(String value) {
    return switch (value.toLowerCase()) {
      'income' => ExpenseType.income,
      'expense' => ExpenseType.expense,
      _ => ExpenseType.expense,
    };
  }
}

class Expense {
  final String id;
  final String title;
  final double amount;
  final ExpenseType type;
  final DateTime date;
  final int userId;
  final String? category;
  final String? description;

  Expense({
    String? id,
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
    required this.userId,
    this.category,
    this.description,
  }) : id = id ?? const Uuid().v4();

  /// Factory constructor untuk parse dari JSON
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String?,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: ExpenseTypeExtension.fromString(json['type'] as String),
      date: json['date'] is DateTime
          ? json['date'] as DateTime
          : DateTime.parse(json['date'] as String),
      userId: json['userId'] as int,
      category: json['category'] as String?,
      description: json['description'] as String?,
    );
  }

  /// Convert ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type.value,
      'date': date.toIso8601String(),
      'userId': userId,
      'category': category,
      'description': description,
    };
  }

  /// Copy with untuk immutability
  Expense copyWith({
    String? id,
    String? title,
    double? amount,
    ExpenseType? type,
    DateTime? date,
    int? userId,
    String? category,
    String? description,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      date: date ?? this.date,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      description: description ?? this.description,
    );
  }

  @override
  String toString() =>
      'Expense(id: $id, title: $title, amount: $amount, type: ${type.displayName}, date: $date)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Expense &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          amount == other.amount &&
          type == other.type &&
          date == other.date &&
          userId == other.userId;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      amount.hashCode ^
      type.hashCode ^
      date.hashCode ^
      userId.hashCode;
}
