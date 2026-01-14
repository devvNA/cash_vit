import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cash Vit',
      theme: AppTheme.lightTheme,
      home: const _ThemePreviewScreen(),
    );
  }
}

class _ThemePreviewScreen extends StatelessWidget {
  const _ThemePreviewScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cash Vit')),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Heading Large',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Heading Medium',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Body Large', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: AppSpacing.xl),
            // Balance preview
            Container(
              padding: AppSpacing.cardPadding,
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: AppRadius.cardRadius,
                boxShadow: AppShadow.cardShadow,
              ),
              child: Column(
                children: [
                  Text(
                    'Balance',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Rp 1.500.000',
                    style: AppTypography.displayAmount.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSummaryItem(
                        context,
                        'Income',
                        'Rp 2.000.000',
                        AppColors.incomeGreen,
                      ),
                      _buildSummaryItem(
                        context,
                        'Expense',
                        'Rp 500.000',
                        AppColors.expenseRed,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            // Buttons
            ElevatedButton(
              onPressed: () {},
              child: const Text('Primary Button'),
            ),
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton(
              onPressed: () {},
              child: const Text('Outlined Button'),
            ),
            const SizedBox(height: AppSpacing.xl),
            // Input
            const TextField(
              decoration: InputDecoration(
                labelText: 'Username',
                hintText: 'Enter username',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    String amount,
    Color color,
  ) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: AppSpacing.xs),
        Text(amount, style: AppTypography.amountMedium.copyWith(color: color)),
      ],
    );
  }
}
