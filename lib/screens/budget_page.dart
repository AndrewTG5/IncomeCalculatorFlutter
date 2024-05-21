import 'package:flutter/material.dart';
import 'package:income_calculator/data/budget.dart';
import 'package:income_calculator/utils.dart';
import 'package:income_calculator/screens/budget_view_model.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});
  final String title = "Budget Calculator";

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BudgetViewModel(),
      builder: (context, child) {
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                onChanged: (String value) {
                  Provider.of<BudgetViewModel>(context, listen: false)
                      .onIncomeChanged(double.tryParse(value) ?? 0);
                },
                decoration: const InputDecoration(
                  labelText: 'Income \$',
                ),
              ),
              const BudgetForm(),
              TextButton(
                onPressed: () {
                  _showMyDialog(context, save: (newExpense) {
                    Provider.of<BudgetViewModel>(context, listen: false)
                        .onExpenseAdded(newExpense);
                  });
                },
                child: const Text('Add Expense'),
              ),
              DropdownButton(
                value: Provider
                    .of<BudgetViewModel>(context)
                    .showPeriod,
                onChanged: (int? newValue) {
                  Provider.of<BudgetViewModel>(context, listen: false)
                      .onPeriodChanged(newValue!);
                },
                items: const <DropdownMenuItem<int>>[
                  DropdownMenuItem(
                    value: 0,
                    child: Text('Yearly'),
                  ),
                  DropdownMenuItem(
                    value: 1,
                    child: Text('Monthly'),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Text('Fortnightly'),
                  ),
                  DropdownMenuItem(
                    value: 3,
                    child: Text('Weekly'),
                  ),
                  DropdownMenuItem(
                    value: 4,
                    child: Text('Daily'),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                child: const BudgetChart(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MyDialog extends StatefulWidget {
  final Expense? oldExpense;
  final Function(Expense newExpense) save;

  const MyDialog({super.key, this.oldExpense, required this.save});

  @override
  State createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  late TextEditingController nameController;
  late TextEditingController amountController;
  late ExpenseOccurrence occurrence;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.oldExpense?.name);
    amountController = TextEditingController(text: widget.oldExpense?.amount.toString());
    occurrence = widget.oldExpense?.occurrence ?? ExpenseOccurrence.oneOff;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.oldExpense == null ? const Text('Add Expense') : const Text('Edit Expense'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Expanded(child:
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            ),
            Expanded(child:
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Amount \$',
              ),
            ),
            ),
            DropdownButton<ExpenseOccurrence>(
              value: occurrence,
              onChanged: (ExpenseOccurrence? newValue) {
                setState(() {
                  occurrence = newValue!;
                });
              },
              items: const <DropdownMenuItem<ExpenseOccurrence>>[
                DropdownMenuItem(
                  value: ExpenseOccurrence.oneOff,
                  child: Text('One-off'),
                ),
                DropdownMenuItem(
                  value: ExpenseOccurrence.daily,
                  child: Text('Day'),
                ),
                DropdownMenuItem(
                  value: ExpenseOccurrence.weekly,
                  child: Text('Week'),
                ),
                DropdownMenuItem(
                  value: ExpenseOccurrence.monthly,
                  child: Text('Month'),
                ),
                DropdownMenuItem(
                  value: ExpenseOccurrence.yearly,
                  child: Text('Year'),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Save'),
          onPressed: () {
            final name = nameController.text;
            final amount = double.tryParse(amountController.text);
            if (amount != null) {
              widget.save(Expense(name, amount, occurrence));
            }
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

Future<void> _showMyDialog(BuildContext context, {Expense? oldExpense, required Function(Expense newExpense) save}) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return MyDialog(oldExpense: oldExpense, save: save);
    },
  );
}

// a data table that displays each expense. has the columns: name, amount, period, and actions (delete and edit)
class BudgetForm extends StatelessWidget {
  const BudgetForm({super.key});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Text('Name'),
        ),
        DataColumn(
          label: Text('Amount'),
        ),
        DataColumn(
          label: Text('Period'),
        ),
        DataColumn(
          label: Text('Actions'),
        ),
      ],
      rows: Provider.of<BudgetViewModel>(context).expenses.map((expense) {
        return DataRow(
          cells: <DataCell>[
            DataCell(Text(expense.name)),
            DataCell(Text(expense.amount.toString())),
            DataCell(Text(expense.occurrenceString)),
            DataCell(Row(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    Provider.of<BudgetViewModel>(context, listen: false).onExpenseRemoved(expense);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showMyDialog(context, oldExpense: expense, save: (newExpense) {
                      Provider.of<BudgetViewModel>(context, listen: false).onExpenseUpdated(expense, newExpense);
                    });
                  },
                ),
              ],
            )),
          ],
        );
      }).toList(),
    );
  }
}

class BudgetChart extends StatelessWidget {
  const BudgetChart({super.key});

  @override
  Widget build(BuildContext context) {
    late final Map<String, double> budget;
    switch (Provider
        .of<BudgetViewModel>(context)
        .showPeriod) {
      case 0:
        budget = Provider
            .of<BudgetViewModel>(context)
            .budgetCalculator
            .getYearlyBudget();
        break;
      case 1:
        budget = Provider
            .of<BudgetViewModel>(context)
            .budgetCalculator
            .getMonthlyBudget();
        break;
      case 2:
        budget = Provider
            .of<BudgetViewModel>(context)
            .budgetCalculator
            .getFortnightlyBudget();
        break;
      case 3:
        budget = Provider
            .of<BudgetViewModel>(context)
            .budgetCalculator
            .getWeeklyBudget();
        break;
      case 4:
        budget = Provider
            .of<BudgetViewModel>(context)
            .budgetCalculator
            .getDailyBudget();
        break;
    }

    if (Provider.of<BudgetViewModel>(context).expenses.isEmpty) {
      return const Text('No data to show');
    }

    return PieChart(
      PieChartData(
        sections: budget.entries.map((entry) {
          return PieChartSectionData(
            radius: 200,
            value: entry.value,
            title: "${entry.key}: ${formatAsCurrency(entry.value)}\n ${roundToTwoDecimalPlaces((entry.value / budget.values.reduce((a, b) => a + b))*100)}%",
            color: Color((entry.key.hashCode & 0xFFFFFF).toUnsigned(32) | 0xFF000000),
          );
        }).toList(),
        centerSpaceRadius: 0,
      ),
    );
  }
}