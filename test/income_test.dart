import 'package:flutter_test/flutter_test.dart';
import 'package:income_calculator/data/income.dart';

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
      expect(Income.roundToTwoDecimalPlaces(1.2345), 1.23);
      expect(Income.roundToTwoDecimalPlaces(1.2355), 1.24);
      expect(Income.roundToTwoDecimalPlaces(1.0), 1.0);
      expect(Income.roundToTwoDecimalPlaces(1.23456789), 1.23);
      expect(Income.roundToTwoDecimalPlaces(0.377), 0.38);
      expect(Income.roundToTwoDecimalPlaces(0.371), 0.37);
      expect(Income.roundToTwoDecimalPlaces(287.371238712368), 287.37);
      expect(Income.roundToTwoDecimalPlaces(287.374938712368), 287.37);
      expect(Income.roundToTwoDecimalPlaces(287.375238712368), 287.38);
      expect(Income.roundToTwoDecimalPlaces(287.376238712368), 287.38);
      expect(Income.roundToTwoDecimalPlaces(287.38462), 287.38);
    });
  });

  group('Income', () {
    test('Income \$35/h, guessed, 3% ks, no sl', () {
      final income = Income(income: 35, period: IncomePeriod.hour, kiwiSaver: 3, studentLoan: false);
      expect(Income.roundToTwoDecimalPlaces(income.grossHourly), 35);
      expect(Income.roundToTwoDecimalPlaces(income.payeHourly), 7.18);
      expect(Income.roundToTwoDecimalPlaces(income.accHourly), 0.56);
      expect(Income.roundToTwoDecimalPlaces(income.kiwiSaverHourly), 1.05);
      expect(Income.roundToTwoDecimalPlaces(income.studentLoanHourly), 0.0);
      expect(Income.roundToTwoDecimalPlaces(income.netHourly), 26.21);

      expect(Income.roundToTwoDecimalPlaces(income.grossDaily), 280);
      expect(Income.roundToTwoDecimalPlaces(income.payeDaily), 57.48);
      expect(Income.roundToTwoDecimalPlaces(income.accDaily), 4.48);
      expect(Income.roundToTwoDecimalPlaces(income.kiwiSaverDaily), 8.4);
      expect(Income.roundToTwoDecimalPlaces(income.studentLoanDaily), 0.0);
      expect(Income.roundToTwoDecimalPlaces(income.netDaily), 209.64);

      expect(Income.roundToTwoDecimalPlaces(income.grossWeekly), 1400);
      expect(Income.roundToTwoDecimalPlaces(income.payeWeekly), 287.38);
      expect(Income.roundToTwoDecimalPlaces(income.accWeekly), 22.4);
      expect(Income.roundToTwoDecimalPlaces(income.kiwiSaverWeekly), 42.0);
      expect(Income.roundToTwoDecimalPlaces(income.studentLoanWeekly), 0.0);
      expect(Income.roundToTwoDecimalPlaces(income.netWeekly), 1048.22);

      expect(Income.roundToTwoDecimalPlaces(income.grossFortnightly), 2800);
      expect(Income.roundToTwoDecimalPlaces(income.payeFortnightly), 574.77);
      expect(Income.roundToTwoDecimalPlaces(income.accFortnightly), 44.8);
      expect(Income.roundToTwoDecimalPlaces(income.kiwiSaverFortnightly), 84.0);
      expect(Income.roundToTwoDecimalPlaces(income.studentLoanFortnightly), 0.0);
      expect(Income.roundToTwoDecimalPlaces(income.netFortnightly), 2096.43);

      expect(Income.roundToTwoDecimalPlaces(income.grossMonthly), 6066.67);
      expect(Income.roundToTwoDecimalPlaces(income.payeMonthly), 1245.33);
      expect(Income.roundToTwoDecimalPlaces(income.accMonthly), 97.07);
      expect(Income.roundToTwoDecimalPlaces(income.kiwiSaverMonthly), 182.0);
      expect(Income.roundToTwoDecimalPlaces(income.studentLoanMonthly), 0.0);
      expect(Income.roundToTwoDecimalPlaces(income.netMonthly), 4542.27);

      expect(Income.roundToTwoDecimalPlaces(income.grossYearly), 72800);
      expect(Income.roundToTwoDecimalPlaces(income.payeYearly), 14944);
      expect(Income.roundToTwoDecimalPlaces(income.accYearly), 1164.8);
      expect(Income.roundToTwoDecimalPlaces(income.kiwiSaverYearly), 2184.0);
      expect(Income.roundToTwoDecimalPlaces(income.studentLoanYearly), 0.0);
      expect(Income.roundToTwoDecimalPlaces(income.netYearly), 54507.20);
    });
  });
}