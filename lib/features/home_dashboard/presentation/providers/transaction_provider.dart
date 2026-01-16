import 'package:cash_vit/features/home_dashboard/data/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_provider.g.dart';

/// Sealed class representing all possible transaction states
sealed class TransactionState {
  const TransactionState();
}

/// Initial state
class TransactionInitial extends TransactionState {
  const TransactionInitial();
}

/// Loaded state with transactions and calculated totals
class TransactionLoaded extends TransactionState {
  final List<Expense> transactions;
  final double totalIncome;
  final double totalExpense;
  final double balance;

  const TransactionLoaded({
    required this.transactions,
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
  });
}

/// Category helper class
class TransactionCategory {
  final String name;
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  const TransactionCategory({
    required this.name,
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });

  static const List<TransactionCategory> categories = [
    TransactionCategory(
      name: 'Food',
      icon: Icons.restaurant,
      color: Color(0xFFEF6C00),
      backgroundColor: Color(0xFFFFF3E0),
    ),
    TransactionCategory(
      name: 'Salary',
      icon: Icons.payments,
      color: Color(0xFF2E7D32),
      backgroundColor: Color(0xFFE8F5E9),
    ),
    TransactionCategory(
      name: 'Entertainment',
      icon: Icons.confirmation_number,
      color: Color(0xFF6A1B9A),
      backgroundColor: Color(0xFFF3E5F5),
    ),
    TransactionCategory(
      name: 'Fuel',
      icon: Icons.directions_car,
      color: Color(0xFFEF6C00),
      backgroundColor: Color(0xFFE3F2FD),
    ),
    TransactionCategory(
      name: 'Shopping',
      icon: Icons.shopping_bag,
      color: Color(0xFFD81B60),
      backgroundColor: Color(0xFFFCE4EC),
    ),
    TransactionCategory(
      name: 'Other',
      icon: Icons.category,
      color: Color(0xFF455A64),
      backgroundColor: Color(0xFFECEFF1),
    ),
  ];

  static TransactionCategory getByName(String name) {
    return categories.firstWhere(
      (c) => c.name.toLowerCase() == name.toLowerCase(),
      orElse: () => categories.last,
    );
  }
}

/// Transaction notifier managing in-memory transaction storage
@riverpod
class TransactionNotifier extends _$TransactionNotifier {
  final List<Expense> _transactions = [];

  @override
  TransactionState build() {
    _initializeSampleData();
    return _calculateState();
  }

  /// Initialize with sample data
  void _initializeSampleData() {
    final now = DateTime.now();
    _transactions.addAll([
      Expense(
        title: 'Food',
        amount: 25000,
        type: ExpenseType.expense,
        date: now,
        userId: 1,
        category: 'Food',
      ),
      Expense(
        title: 'Salary',
        amount: 125000,
        type: ExpenseType.income,
        date: now.subtract(const Duration(days: 1)),
        userId: 1,
        category: 'Salary',
      ),
      Expense(
        title: 'Entertainment',
        amount: 250000,
        type: ExpenseType.expense,
        date: now.subtract(const Duration(days: 1)),
        userId: 1,
        category: 'Entertainment',
      ),
      Expense(
        title: 'Fuel',
        amount: 50000,
        type: ExpenseType.expense,
        date: now.subtract(const Duration(days: 2)),
        userId: 1,
        category: 'Fuel',
      ),
    ]);
  }

  /// Add new transaction
  void addTransaction(Expense expense) {
    _transactions.insert(0, expense); // Add to beginning
    state = _calculateState();
  }

  /// Delete transaction by ID
  void deleteTransaction(String id) {
    _transactions.removeWhere((e) => e.id == id);
    state = _calculateState();
  }

  /// Calculate totals and return new state
  TransactionLoaded _calculateState() {
    final income = _transactions
        .where((e) => e.type == ExpenseType.income)
        .fold(0.0, (sum, e) => sum + e.amount);

    final expense = _transactions
        .where((e) => e.type == ExpenseType.expense)
        .fold(0.0, (sum, e) => sum + e.amount);

    // Sort by date descending
    final sorted = List<Expense>.from(_transactions)
      ..sort((a, b) => b.date.compareTo(a.date));

    return TransactionLoaded(
      transactions: List.unmodifiable(sorted),
      totalIncome: income,
      totalExpense: expense,
      balance: income - expense,
    );
  }
}
