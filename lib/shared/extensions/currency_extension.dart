import 'package:intl/intl.dart';

extension NumCurrencyExtension on num {
  String get currencyFormatRp => NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(this);

  /// Format number dengan titik sebagai pemisah ribuan (tanpa simbol Rp)
  /// Contoh: 1000000 -> "1.000.000"
  String get toFormattedString => NumberFormat('#,###', 'id').format(this);

  /// Format number dengan titik sebagai pemisah ribuan dan prefix Rp
  /// Contoh: 1000000 -> "Rp 1.000.000"
  String get toRupiah => 'Rp ${NumberFormat('#,###', 'id').format(this)}';
}

extension StringCurrencyExtension on String {
  String get currencyFormatRp => NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(num.parse(this));

  /// Format string number dengan titik sebagai pemisah ribuan (tanpa simbol Rp)
  /// Contoh: "1000000" -> "1.000.000"
  String get toFormattedString {
    try {
      final number = num.parse(this);
      return NumberFormat('#,###', 'id').format(number);
    } catch (e) {
      return this; // Return original string if parsing fails
    }
  }

  /// Format string number dengan titik sebagai pemisah ribuan dan prefix Rp
  /// Contoh: "1000000" -> "Rp 1.000.000"
  String get toRupiah {
    try {
      final number = num.parse(this);
      return 'Rp ${NumberFormat('#,###', 'id').format(number)}';
    } catch (e) {
      return this; // Return original string if parsing fails
    }
  }
}

class CurrencyFormat {
  static String convertToIdr(dynamic number, {int? decimalDigit}) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp',
      decimalDigits: decimalDigit ?? 0,
    );
    return currencyFormatter.format(number);
  }
}
