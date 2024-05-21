import 'package:flutter/material.dart';
import 'package:income_calculator/data/budget.dart';

class BudgetViewModel extends ChangeNotifier {
  double _income = 0;
  double get income => _income;
  final List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;
  BudgetCalculator _budgetCalculator = BudgetCalculator(0, []);
  BudgetCalculator get budgetCalculator => _budgetCalculator;
  int _showPeriod = 0; // 0 for yearly, 1 for monthly, 2 for fortnightly, 3 for weekly, 4 for daily
  int get showPeriod => _showPeriod;

  void onPeriodChanged(int period) {
    _showPeriod = period;
    notifyListeners();
  }

  void _calculateBudget() {
    _budgetCalculator = BudgetCalculator(_income, _expenses);
    notifyListeners();
  }

  void onIncomeChanged(double income) {
    _income = income;
    _calculateBudget();
  }

  void onExpenseAdded(Expense expense) {
    _expenses.add(expense);
    _calculateBudget();
  }

  void onExpenseRemoved(Expense expense) {
    _expenses.remove(expense);
    _calculateBudget();
  }

  void onExpenseUpdated(Expense oldExpense, Expense newExpense) {
    final index = _expenses.indexOf(oldExpense);
    _expenses[index] = newExpense;
    _calculateBudget();
  }

}