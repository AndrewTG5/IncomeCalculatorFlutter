library budget;

enum ExpenseOccurrence { oneOff, daily, weekly, monthly, yearly }

class Expense {
  String name;
  double amount;
  ExpenseOccurrence occurrence;
  String get occurrenceString {
    switch (occurrence) {
      case ExpenseOccurrence.daily:
        return 'Daily';
      case ExpenseOccurrence.weekly:
        return 'Weekly';
      case ExpenseOccurrence.monthly:
        return 'Monthly';
      case ExpenseOccurrence.yearly:
        return 'Yearly';
      case ExpenseOccurrence.oneOff:
        return 'One-off';
    }
  }

  Expense(this.name, this.amount, this.occurrence);
}

class BudgetCalculator {
  final double yearlySalary;
  final List<Expense> expenses;

  BudgetCalculator(this.yearlySalary, this.expenses);

  // Return a list of expenses for the given period. Also calculate the remaining salary after deducting the expenses, and return it as well
  Map<String, double> getYearlyBudget() {
    double remainingSalary = yearlySalary;
    final budget = <String, double>{};

    for (final expense in expenses) {
      switch (expense.occurrence) {
        case ExpenseOccurrence.daily:
          double amount = expense.amount * 365;
          budget[expense.name] = amount;
          remainingSalary -= amount;
          break;
        case ExpenseOccurrence.weekly:
          double amount = expense.amount * 52;
          budget[expense.name] = amount;
          remainingSalary -= amount;
          break;
        case ExpenseOccurrence.monthly:
          double amount = expense.amount * 12;
          budget[expense.name] = amount;
          remainingSalary -= amount;
          break;
        case ExpenseOccurrence.yearly:
          budget[expense.name] = expense.amount;
          remainingSalary -= expense.amount;
          break;
        case ExpenseOccurrence.oneOff:
          budget[expense.name] = expense.amount;
          remainingSalary -= expense.amount;
          break;
      }
    }

    budget['Remaining Salary'] = remainingSalary;
    return budget;
  }

  Map<String, double> getMonthlyBudget() {
    double remainingSalary = yearlySalary/12;
    final budget = <String, double>{};

    for (final expense in expenses) {
      switch (expense.occurrence) {
        case ExpenseOccurrence.daily:
          double amount = expense.amount * 30;
          budget[expense.name] = amount;
          remainingSalary -= amount;
          break;
        case ExpenseOccurrence.weekly:
          double amount = expense.amount * 4;
          budget[expense.name] = amount;
          remainingSalary -= amount;
          break;
        case ExpenseOccurrence.monthly:
          budget[expense.name] = expense.amount;
          remainingSalary -= expense.amount;
          break;
        case ExpenseOccurrence.yearly:
          double amount = expense.amount / 12;
          budget[expense.name] = amount;
          remainingSalary -= amount;
          break;
        case ExpenseOccurrence.oneOff:
          budget[expense.name] = expense.amount;
          remainingSalary -= expense.amount;
          break;
      }
    }

    budget['Remaining Salary'] = remainingSalary;
    return budget;
  }

  Map<String, double> getFortnightlyBudget() {
    double remainingSalary = yearlySalary/26;
    final budget = <String, double>{};

    for (final expense in expenses) {
      switch (expense.occurrence) {
        case ExpenseOccurrence.daily:
          double amount = expense.amount * 14;
          budget[expense.name] = amount;
          remainingSalary -= amount;
          break;
        case ExpenseOccurrence.weekly:
          double amount = expense.amount * 2;
          budget[expense.name] = amount;
          remainingSalary -= amount;
          break;
        case ExpenseOccurrence.monthly:
          double amount = expense.amount / 2;
          budget[expense.name] = amount;
          remainingSalary -= amount;
          break;
        case ExpenseOccurrence.yearly:
          double amount = expense.amount / 26;
          budget[expense.name] = amount;
          remainingSalary -= amount;
          break;
        case ExpenseOccurrence.oneOff:
          budget[expense.name] = expense.amount;
          remainingSalary -= expense.amount;
          break;
      }
    }

    budget['Remaining Salary'] = remainingSalary;
    return budget;
  }

  Map<String, double> getWeeklyBudget() {
    double remainingSalary = yearlySalary/52;
    final budget = <String, double>{};

    for (final expense in expenses) {
      switch (expense.occurrence) {
        case ExpenseOccurrence.daily:
          double amount = expense.amount * 7;
          budget[expense.name] = amount;
          remainingSalary -= amount;
          break;
        case ExpenseOccurrence.weekly:
          budget[expense.name] = expense.amount;
          remainingSalary -= expense.amount;
          break;
        case ExpenseOccurrence.monthly:
          double amount = expense.amount / 4;
          budget[expense.name] = amount;
          remainingSalary -= amount;
          break;
        case ExpenseOccurrence.yearly:
          double amount = expense.amount / 52;
          budget[expense.name] = amount;
          remainingSalary -= amount;
          break;
        case ExpenseOccurrence.oneOff:
          budget[expense.name] = expense.amount;
          remainingSalary -= expense.amount;
          break;
      }
    }

    budget['Remaining Salary'] = remainingSalary;
    return budget;
  }

  Map<String, double> getDailyBudget() {
    double remainingSalary = yearlySalary/365;
    final budget = <String, double>{};

    for (final expense in expenses) {
      switch (expense.occurrence) {
        case ExpenseOccurrence.daily:
          budget[expense.name] = expense.amount;
          remainingSalary -= expense.amount;
          break;
        case ExpenseOccurrence.weekly:
          double amount = expense.amount / 7;
          budget[expense.name] = amount;
          remainingSalary -= amount;
          break;
        case ExpenseOccurrence.monthly:
          double amount = expense.amount / 30;
          budget[expense.name] = amount;
          remainingSalary -= amount;
          break;
        case ExpenseOccurrence.yearly:
          double amount = expense.amount / 365;
          budget[expense.name] = amount;
          remainingSalary -= amount;
          break;
        case ExpenseOccurrence.oneOff:
          budget[expense.name] = expense.amount;
          remainingSalary -= expense.amount;
          break;
      }
    }

    budget['Remaining Salary'] = remainingSalary;
    return budget;
  }

}
