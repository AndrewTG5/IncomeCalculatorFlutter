import 'package:flutter/material.dart';
import 'package:income_calculator/income.dart';

class IncomeViewModel extends ChangeNotifier {
   Income? _income;
   Income? get income => _income;

   void onCalculate(double income, IncomePeriod period, int kiwiSaver, bool studentLoan) {
     _income = Income(income: income, period: period, kiwiSaver: kiwiSaver, studentLoan: studentLoan);
     notifyListeners();
   }

}
