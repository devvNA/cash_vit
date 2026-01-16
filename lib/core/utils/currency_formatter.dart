import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class IndonesianCurrencyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 1. Handle empty input
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // 2. Remove non-digits to get raw value
    // ignore: deprecated_member_use
    final String onlyDigits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // 3. Parse as integer (assuming no decimals for this standard formatter)
    final int value = int.tryParse(onlyDigits) ?? 0;

    // 4. Format with Indonesian locale (dots for thousands)
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    );

    final String newText = formatter.format(value).trim();

    // 5. Build and return the new TextEditingValue
    // We simple place the cursor at the end for this basic implementation.
    // Ideally, for editing in the middle, more complex cursor logic is needed,
    // but for standard numeric entry, end-cursor is the standard behavior.
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
