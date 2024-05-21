import 'package:flutter_test/flutter_test.dart';
import 'package:income_calculator/data/income.dart';
import 'package:income_calculator/utils.dart';

void main() {

  group('Utility', () {
    test('Guess period', () {
      expect(Income.guessPeriod(35), IncomePeriod.hour);
      expect(Income.guessPeriod(249), IncomePeriod.hour);
      expect(Income.guessPeriod(250), IncomePeriod.week);
      expect(Income.guessPeriod(5000), IncomePeriod.week);
      expect(Income.guessPeriod(5001), IncomePeriod.year);
      expect(Income.guessPeriod(75000), IncomePeriod.year);
    });
    test('Round to two decimal places', () {
      expect(roundToTwoDecimalPlaces(1.2345), 1.23);
      expect(roundToTwoDecimalPlaces(1.2355), 1.24);
      expect(roundToTwoDecimalPlaces(1.0), 1.0);
      expect(roundToTwoDecimalPlaces(1.23456789), 1.23);
      expect(roundToTwoDecimalPlaces(0.377), 0.38);
      expect(roundToTwoDecimalPlaces(0.371), 0.37);
      expect(roundToTwoDecimalPlaces(287.371238712368), 287.37);
      expect(roundToTwoDecimalPlaces(287.374938712368), 287.37);
      expect(roundToTwoDecimalPlaces(287.375238712368), 287.38);
      expect(roundToTwoDecimalPlaces(287.376238712368), 287.38);
      expect(roundToTwoDecimalPlaces(287.38462), 287.38);
    });
  });

  group('Income', () {
    test('Income \$35/h, guessed, 3% ks, no sl', () {
      final income = Income(income: 35, period: IncomePeriod.hour, kiwiSaver: 3, studentLoan: false);
      expect(roundToTwoDecimalPlaces(income.grossHourly), 35);
      expect(roundToTwoDecimalPlaces(income.payeHourly), 7.18);
      expect(roundToTwoDecimalPlaces(income.accHourly), 0.56);
      expect(roundToTwoDecimalPlaces(income.kiwiSaverHourly), 1.05);
      expect(roundToTwoDecimalPlaces(income.studentLoanHourly), 0.0);
      expect(roundToTwoDecimalPlaces(income.netHourly), 26.21);

      expect(roundToTwoDecimalPlaces(income.grossDaily), 280);
      expect(roundToTwoDecimalPlaces(income.payeDaily), 57.48);
      expect(roundToTwoDecimalPlaces(income.accDaily), 4.48);
      expect(roundToTwoDecimalPlaces(income.kiwiSaverDaily), 8.4);
      expect(roundToTwoDecimalPlaces(income.studentLoanDaily), 0.0);
      expect(roundToTwoDecimalPlaces(income.netDaily), 209.64);

      expect(roundToTwoDecimalPlaces(income.grossWeekly), 1400);
      expect(roundToTwoDecimalPlaces(income.payeWeekly), 287.38);
      expect(roundToTwoDecimalPlaces(income.accWeekly), 22.4);
      expect(roundToTwoDecimalPlaces(income.kiwiSaverWeekly), 42.0);
      expect(roundToTwoDecimalPlaces(income.studentLoanWeekly), 0.0);
      expect(roundToTwoDecimalPlaces(income.netWeekly), 1048.22);

      expect(roundToTwoDecimalPlaces(income.grossFortnightly), 2800);
      expect(roundToTwoDecimalPlaces(income.payeFortnightly), 574.77);
      expect(roundToTwoDecimalPlaces(income.accFortnightly), 44.8);
      expect(roundToTwoDecimalPlaces(income.kiwiSaverFortnightly), 84.0);
      expect(roundToTwoDecimalPlaces(income.studentLoanFortnightly), 0.0);
      expect(roundToTwoDecimalPlaces(income.netFortnightly), 2096.43);

      expect(roundToTwoDecimalPlaces(income.grossMonthly), 6066.67);
      expect(roundToTwoDecimalPlaces(income.payeMonthly), 1245.33);
      expect(roundToTwoDecimalPlaces(income.accMonthly), 97.07);
      expect(roundToTwoDecimalPlaces(income.kiwiSaverMonthly), 182.0);
      expect(roundToTwoDecimalPlaces(income.studentLoanMonthly), 0.0);
      expect(roundToTwoDecimalPlaces(income.netMonthly), 4542.27);

      expect(roundToTwoDecimalPlaces(income.grossYearly), 72800);
      expect(roundToTwoDecimalPlaces(income.payeYearly), 14944);
      expect(roundToTwoDecimalPlaces(income.accYearly), 1164.8);
      expect(roundToTwoDecimalPlaces(income.kiwiSaverYearly), 2184.0);
      expect(roundToTwoDecimalPlaces(income.studentLoanYearly), 0.0);
      expect(roundToTwoDecimalPlaces(income.netYearly), 54507.20);
    });
  });
}