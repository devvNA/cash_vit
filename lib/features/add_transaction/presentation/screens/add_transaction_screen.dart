import 'package:cash_vit/core/themes/index.dart';
import 'package:cash_vit/features/add_transaction/presentation/widgets/add_transaction_actions.dart';
import 'package:cash_vit/features/add_transaction/presentation/widgets/add_transaction_header.dart';
import 'package:cash_vit/features/add_transaction/presentation/widgets/amount_input_card.dart';
import 'package:cash_vit/features/add_transaction/presentation/widgets/category_selector.dart';
import 'package:cash_vit/features/add_transaction/presentation/widgets/expense_type_selector.dart';
import 'package:cash_vit/features/add_transaction/presentation/widgets/payment_method_selector.dart';
import 'package:cash_vit/features/add_transaction/presentation/widgets/success_dialog.dart';
import 'package:cash_vit/features/add_transaction/presentation/widgets/title_input_card.dart';
import 'package:cash_vit/features/home_dashboard/data/models/expense_model.dart';
import 'package:cash_vit/features/home_dashboard/presentation/providers/transaction_provider.dart';
import 'package:cash_vit/shared/widgets/background_glows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

enum _PaymentType { cash, card, check }

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  _PaymentType _paymentType = _PaymentType.cash;
  ExpenseType _expenseType = ExpenseType.expense;
  TransactionCategory _selectedCategory = TransactionCategory.categories.first;

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _handleAddTransaction() async {
    // Validate
    final title = _titleController.text.trim();
    final amountText = _amountController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title'),
          backgroundColor: AppColors.expenseRed,
        ),
      );
      return;
    }

    // Remove dots (thousand separators) before parsing
    final cleanAmountText = amountText.replaceAll('.', '');
    final amount = double.tryParse(cleanAmountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount'),
          backgroundColor: AppColors.expenseRed,
        ),
      );
      return;
    }

    // Create expense
    final expense = Expense(
      title: title,
      amount: amount,
      type: _expenseType,
      date: DateTime.now(),
      userId: 1,
      category: _selectedCategory.name,
    );

    // Add via provider
    ref.read(transactionProvider.notifier).addTransaction(expense);

    // Show success animation
    await _showSuccessAnimation();

    if (!mounted) return;

    // Navigate back
    Navigator.pop(context);
  }

  Future<void> _showSuccessAnimation() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) => const SuccessDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Stack(
          children: [
            const BackgroundGlows(),
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      left: AppSpacing.paddingScreen,
                      right: AppSpacing.paddingScreen,
                      top: AppSpacing.lg,
                      bottom: AppSpacing.xxl + AppSpacing.xl,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const AddTransactionHeader(),
                        SizedBox(height: AppSpacing.lg),
                        TitleInputCard(controller: _titleController),
                        SizedBox(height: AppSpacing.md),
                        AmountInputCard(controller: _amountController),
                        SizedBox(height: AppSpacing.md),
                        ExpenseTypeSelector(
                          selectedType: _expenseType,
                          onTypeChanged: (type) =>
                              setState(() => _expenseType = type),
                        ),
                        SizedBox(height: AppSpacing.md),
                        CategorySelector(
                          selectedCategory: _selectedCategory,
                          onCategoryChanged: (category) =>
                              setState(() => _selectedCategory = category),
                        ),
                        SizedBox(height: AppSpacing.xl),
                        const SectionTitle('Payment Type'),
                        PaymentMethodSelector(
                          label: 'Cash',
                          selected: _paymentType == _PaymentType.cash,
                          onTap: () =>
                              setState(() => _paymentType = _PaymentType.cash),
                          emphasized: true,
                        ),
                        SizedBox(height: AppSpacing.sm),
                        PaymentMethodSelector(
                          label: 'Credit/Debit Card',
                          selected: _paymentType == _PaymentType.card,
                          onTap: () =>
                              setState(() => _paymentType = _PaymentType.card),
                        ),
                        SizedBox(height: AppSpacing.sm),
                        PaymentMethodSelector(
                          label: 'Check',
                          selected: _paymentType == _PaymentType.check,
                          onTap: () =>
                              setState(() => _paymentType = _PaymentType.check),
                        ),
                      ],
                    ),
                  ),
                ),
                AddTransactionActions(
                  onDraft: () {},
                  onAdd: _handleAddTransaction,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: AppTypography.headline6),
    );
  }
}
