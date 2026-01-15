import 'package:cash_vit/core/themes/index.dart';
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
  final TextEditingController _amountController = TextEditingController(
    text: '12.00',
  );
  _PaymentType _paymentType = _PaymentType.cash;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
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
                        const _StatusBar(),
                        SizedBox(height: AppSpacing.md),
                        const _Header(),
                        SizedBox(height: AppSpacing.lg),
                        _AmountCard(controller: _amountController),
                        SizedBox(height: AppSpacing.md),
                        const _CategoryCard(),
                        SizedBox(height: AppSpacing.xl),
                        const _SectionTitle('Payment Type'),
                        _PaymentOption(
                          label: 'Cash',
                          selected: _paymentType == _PaymentType.cash,
                          onTap: () =>
                              setState(() => _paymentType = _PaymentType.cash),
                          emphasized: true,
                        ),
                        SizedBox(height: AppSpacing.sm),
                        _PaymentOption(
                          label: 'Credit/Debit Card',
                          selected: _paymentType == _PaymentType.card,
                          onTap: () =>
                              setState(() => _paymentType = _PaymentType.card),
                        ),
                        SizedBox(height: AppSpacing.sm),
                        _PaymentOption(
                          label: 'Check',
                          selected: _paymentType == _PaymentType.check,
                          onTap: () =>
                              setState(() => _paymentType = _PaymentType.check),
                        ),
                      ],
                    ),
                  ),
                ),
                _ActionButtons(onDraft: () {}, onAdd: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '10:00',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        Row(
          children: const [
            Icon(Icons.signal_cellular_alt, size: 16),
            SizedBox(width: AppSpacing.xs),
            Icon(Icons.wifi, size: 16),
            SizedBox(width: AppSpacing.xs),
            RotatedBox(
              quarterTurns: 1,
              child: Icon(Icons.battery_full, size: 16),
            ),
          ],
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CircleButton(
          icon: Icons.chevron_left,
          onTap: () => Navigator.of(context).maybePop(),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 44),
              child: Text(
                'Add transaction',
                style: AppTypography.headline3.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Icon(icon, color: AppColors.textPrimary),
      ),
    );
  }
}

class _AmountCard extends StatelessWidget {
  final TextEditingController controller;

  const _AmountCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: AppRadius.mediumRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amount',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Text(
                '\$',
                style: AppTypography.headline6.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: AppTypography.headline6.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: const InputDecoration(
                    hintText: '0.00',
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: AppRadius.mediumRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Category',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.categoryEntertainment.withValues(
                        alpha: 0.6,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.restaurant,
                      color: AppColors.warningOrange,
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    'Food',
                    style: AppTypography.headline3.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.expand_more),
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool emphasized;

  const _PaymentOption({
    required this.label,
    required this.selected,
    required this.onTap,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = selected
        ? AppColors.primaryBlue
        : AppColors.borderLight;
    final backgroundColor = selected && emphasized
        ? AppColors.primaryBlue.withValues(alpha: 0.08)
        : AppColors.surfaceWhite;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.cardRadius,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: AppRadius.cardRadius,
          border: Border.all(color: borderColor, width: selected ? 2 : 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            _RadioDot(selected: selected),
            SizedBox(width: AppSpacing.md),
            Text(
              label,
              style: AppTypography.headline4.copyWith(
                color: selected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  final bool selected;

  const _RadioDot({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.primaryBlue : AppColors.borderLight,
          width: 2,
        ),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryBlue : Colors.transparent,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTypography.headline2.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final VoidCallback onDraft;
  final VoidCallback onAdd;

  const _ActionButtons({required this.onDraft, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingScreen,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight.withValues(alpha: 0.9),
        border: const Border(top: BorderSide(color: AppColors.borderLight)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onDraft,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.cardRadius,
                ),
                side: const BorderSide(color: AppColors.borderLight),
                foregroundColor: AppColors.textPrimary,
                backgroundColor: AppColors.surfaceWhite,
              ),
              child: Text(
                'Draft',
                style: AppTypography.headline3.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: ElevatedButton(
              onPressed: onAdd,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.cardRadius,
                ),
                backgroundColor: AppColors.primaryBlue,
                shadowColor: AppColors.primaryBlue.withValues(alpha: 0.35),
                elevation: 8,
              ),
              child: Text(
                'Add',
                style: AppTypography.headline3.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
