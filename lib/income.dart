library income;

import 'package:intl/intl.dart';

enum IncomePeriod { hour, day, week, fortnight, month, year }

class TaxThreshold {
  final double min;
  final double max;
  final double rate;

  TaxThreshold(this.min, this.max, this.rate);
}

final taxRates = [
  TaxThreshold(0, 14000, 10.5),
  TaxThreshold(14000, 48000, 17.5),
  TaxThreshold(48000, 70000, 30.0),
  TaxThreshold(70000, 180000, 33.0),
  TaxThreshold(180000, 9007199254740991, 39.0)
];

/// ACC levy is a flat rate of $1.60 per $100 of income
/// Income must be between $44,250 and $142,283
/// The levy is capped at $2,276.52
/// Sourced April 2024
class ACCLevy {
  static const double levy = 1.60;
  static const int incomeCap = 142283;
  static const int incomeFloor = 44250;
}

class Income {
  late final double _income;
  late final IncomePeriod _period;
  late final int _kiwiSaver;
  late final bool _studentLoan;

  late final double grossHourly;
  late final double payeHourly;
  late final double accHourly;
  late final double kiwiSaverHourly;
  late final double studentLoanHourly;
  late final double netHourly;

  late final double grossDaily;
  late final double payeDaily;
  late final double accDaily;
  late final double kiwiSaverDaily;
  late final double studentLoanDaily;
  late final double netDaily;

  late final double grossWeekly;
  late final double payeWeekly;
  late final double accWeekly;
  late final double kiwiSaverWeekly;
  late final double studentLoanWeekly;
  late final double netWeekly;

  late final double grossFortnightly;
  late final double payeFortnightly;
  late final double accFortnightly;
  late final double kiwiSaverFortnightly;
  late final double studentLoanFortnightly;
  late final double netFortnightly;

  late final double grossMonthly;
  late final double payeMonthly;
  late final double accMonthly;
  late final double kiwiSaverMonthly;
  late final double studentLoanMonthly;
  late final double netMonthly;

  late final double grossYearly;
  late final double payeYearly;
  late final double accYearly;
  late final double kiwiSaverYearly;
  late final double studentLoanYearly;
  late final double netYearly;

  Income({required double income, required IncomePeriod period, int kiwiSaver = 0, bool studentLoan = false}) {
    _income = income;
    _period = period;
    _kiwiSaver = kiwiSaver;
    _studentLoan = studentLoan;

    // Calculate the hourly rate based on the period
    switch (_period) {
      case IncomePeriod.hour:
        grossYearly = _income * 2080;
        break;
      case IncomePeriod.day:
        grossYearly = _income * 260;
        break;
      case IncomePeriod.week:
        grossYearly = _income * 52;
        break;
      case IncomePeriod.fortnight:
        grossYearly = _income * 26;
        break;
      case IncomePeriod.month:
        grossYearly = _income * 12;
        break;
      case IncomePeriod.year:
        grossYearly = _income;
        break;
    }

    grossMonthly = grossYearly / 12;
    grossFortnightly = grossYearly / 26;
    grossWeekly = grossYearly / 52;
    grossDaily = grossYearly / 260;
    grossHourly = grossYearly / 2080;

    payeYearly = _calculatePAYE();
    payeMonthly = payeYearly / 12;
    payeFortnightly = payeYearly / 26;
    payeWeekly = payeYearly / 52;
    payeDaily = payeYearly / 260;
    payeHourly = payeYearly / 2080;

    accYearly = _calculateACC();
    accMonthly = accYearly / 12;
    accFortnightly = accYearly / 26;
    accWeekly = accYearly / 52;
    accDaily = accYearly / 260;
    accHourly = accYearly / 2080;

    kiwiSaverYearly = _calculateKiwiSaver();
    kiwiSaverMonthly = kiwiSaverYearly / 12;
    kiwiSaverFortnightly = kiwiSaverYearly / 26;
    kiwiSaverWeekly = kiwiSaverYearly / 52;
    kiwiSaverDaily = kiwiSaverYearly / 260;
    kiwiSaverHourly = kiwiSaverYearly / 2080;

    studentLoanYearly = _calculateStudentLoan();
    studentLoanMonthly = studentLoanYearly / 12;
    studentLoanFortnightly = studentLoanYearly / 26;
    studentLoanWeekly = studentLoanYearly / 52;
    studentLoanDaily = studentLoanYearly / 260;
    studentLoanHourly = studentLoanYearly / 2080;

    netYearly = grossYearly - payeYearly - accYearly - kiwiSaverYearly - studentLoanYearly;
    netMonthly = netYearly / 12;
    netFortnightly = netYearly / 26;
    netWeekly = netYearly / 52;
    netDaily = netYearly / 260;
    netHourly = netYearly / 2080;
  }

  static double roundToTwoDecimalPlaces(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

  /// Format the value as a currency, for example, 1234.56 will be formatted as 1,234.56
  static String formatAsCurrency(double value) {
    final nzd = NumberFormat("#,##0.00", "en_NZ");
    return nzd.format(roundToTwoDecimalPlaces(value));
  }

  /// Guess the period of the income based on the amount, for example, if the income is $75000, it is likely to be yearly, or if it is $35, it is likely to be hourly
  /// Will not guess day, fortnight, or month
  static IncomePeriod guessPeriod(int income) {
    switch (income) {
      case <= 249:
        return IncomePeriod.hour;
      case >= 250 && <= 5000:
        return IncomePeriod.week;
      case >= 5001:
        return IncomePeriod.year;
      default:
        return IncomePeriod.year;
    }
  }

  /// Calculate the yearly PAYE tax based on the income
  /// If we earn $75,000, the tax is calculated as follows:
  /// 10.5% of $14,000 = $1,470
  /// 17.5% of $34,000 = $5,950
  /// 30% of $20,000 = $6,000
  /// 33% of $7,000 = $2,310
  /// Total tax = $1,470 + $5,950 + $6,000 + $2,310 = $15,730
  double _calculatePAYE() {
    double tax = 0;

    for (var i = 0; i < taxRates.length; i++) {
      if (grossYearly > taxRates[i].max) {
        tax += (taxRates[i].max - taxRates[i].min) * taxRates[i].rate / 100;
      } else {
        tax += (grossYearly - taxRates[i].min) * taxRates[i].rate / 100;
        break;
      }
    }

    return tax;
  }

  double _calculateACC() {
    double acc = 0;
    double income = grossYearly;

    if (income >= ACCLevy.incomeFloor && income <= ACCLevy.incomeCap) {
      acc = income * ACCLevy.levy / 100;
    } else if (income > ACCLevy.incomeCap) {
      acc = ACCLevy.incomeCap * ACCLevy.levy / 100;
    }
    return acc;
  }

  double _calculateKiwiSaver() {
    return grossYearly * _kiwiSaver / 100;
  }

  double _calculateStudentLoan() {
    if (_studentLoan == true && grossYearly > 24128) {
      return grossYearly * 0.12; //TODO: get this from ui
    } else {
      return 0;
    }
  }
}
