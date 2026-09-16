import 'package:intl/intl.dart';

class ConvertDollar {

  String intToDollar(int? value) {
    final format = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$ ',
      decimalDigits: 0
    );

    return format.format(value);
  }
}