import 'package:flutter_test/flutter_test.dart';
import 'package:income_calculator/data/budget.dart';
import 'package:income_calculator/utils.dart';

void main() {
  group('Budget Calculator', () {
    final expenses = <Expense>[
      Expense('Going out', 50, ExpenseOccurrence.oneOff),
      Expense('Rent', 650, ExpenseOccurrence.weekly),
      Expense('Groceries', 100, ExpenseOccurrence.weekly),
      Expense('Internet', 95, ExpenseOccurrence.monthly),
      Expense('Phone', 15, ExpenseOccurrence.monthly),
      Expense('Dentist', 100, ExpenseOccurrence.yearly)
    ];
    final budgetCalculator = BudgetCalculator(50000, expenses);

    test('Get yearly budget', () {
      final budget = budgetCalculator.getYearlyBudget();
      expect(budget['Going out'], 50);
      expect(budget['Rent'], 33800);
      expect(budget['Groceries'], 5200);
      expect(budget['Internet'], 1140);
      expect(budget['Phone'], 180);
      expect(budget['Dentist'], 100);
      expect(budget['Remaining Salary'], 9530);
    });

    test('Get monthly budget', () {
      final budget = budgetCalculator.getMonthlyBudget();
      expect(budget['Going out'], 50);
      expect(budget['Rent'], 2600);
      expect(budget['Groceries'], 400);
      expect(budget['Internet'], 95);
      expect(budget['Phone'], 15);
      expect(roundToTwoDecimalPlaces(budget['Dentist']!), 8.33);
      expect(roundToTwoDecimalPlaces(budget['Remaining Salary']!), 998.33); //998.34?
    });

    test('Get fortnightly budget', () {
      final budget = budgetCalculator.getFortnightlyBudget();
      expect(budget['Going out'], 50);
      expect(budget['Rent'], 1300);
      expect(budget['Groceries'], 200);
      expect(budget['Internet'], 47.5);
      expect(budget['Phone'], 7.5);
      expect(roundToTwoDecimalPlaces(budget['Dentist']!), 3.85);
      expect(roundToTwoDecimalPlaces(budget['Remaining Salary']!), 314.23);
    });

    test('Get weekly budget', () {
      final budget = budgetCalculator.getWeeklyBudget();
      expect(budget['Going out'], 50);
      expect(budget['Rent'], 650);
      expect(budget['Groceries'], 100);
      expect(budget['Internet'], 23.75);
      expect(budget['Phone'], 3.75);
      expect(roundToTwoDecimalPlaces(budget['Dentist']!), 1.92);
      expect(roundToTwoDecimalPlaces(budget['Remaining Salary']!), 132.12);
    });

    test('Get daily budget', () {
      final budget = budgetCalculator.getDailyBudget();
      expect(budget['Going out'], 50);
      expect(roundToTwoDecimalPlaces(budget['Rent']!), 92.86);
      expect(roundToTwoDecimalPlaces(budget['Groceries']!), 14.29);
      expect(roundToTwoDecimalPlaces(budget['Internet']!), 3.17);
      expect(budget['Phone'], 0.5);
      expect(roundToTwoDecimalPlaces(budget['Dentist']!), 0.27);
      expect(roundToTwoDecimalPlaces(budget['Remaining Salary']!), -24.1);
    });
  });

  group('Budget Calculator 2', () {
    final expenses = <Expense>[
      Expense('Rent', 600, ExpenseOccurrence.weekly),
      Expense('Electricity', 80, ExpenseOccurrence.monthly),
      Expense('Internet', 95, ExpenseOccurrence.monthly),
      Expense('Water', 80, ExpenseOccurrence.monthly),
      Expense('Gas', 50, ExpenseOccurrence.monthly),
      Expense('Phone', 45, ExpenseOccurrence.monthly),
      Expense('Petrol', 50, ExpenseOccurrence.weekly),
    ];
    final budgetCalculator = BudgetCalculator(56504, expenses);

    test('Get weekly budget', () {
      final budget = budgetCalculator.getWeeklyBudget();
      expect(budget['Rent'], 600);
      expect(budget['Electricity'], 20);
      expect(budget['Internet'], 23.75);
      expect(budget['Water'], 20);
      expect(budget['Gas'], 12.5);
      expect(budget['Phone'], 11.25);
      expect(budget['Petrol'], 50);
      expect(roundToTwoDecimalPlaces(budget['Remaining Salary']!), 349.12);
    });

  });
}