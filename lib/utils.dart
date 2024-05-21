import 'package:intl/intl.dart';

double roundToTwoDecimalPlaces(double value) {
return double.parse(value.toStringAsFixed(2));
}

/// Format the value as a currency, for example, 1234.56 will be formatted as 1,234.56
String formatAsCurrency(double value) {
final nzd = NumberFormat("#,##0.00", "en_NZ");
return nzd.format(roundToTwoDecimalPlaces(value));
}
