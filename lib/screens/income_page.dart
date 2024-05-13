import 'package:flutter/material.dart';
import 'package:income_calculator/data/income.dart';
import 'package:income_calculator/screens/income_view_model.dart';
import 'package:provider/provider.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});
  final String title = "Income Calculator";

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => IncomeViewModel(),
      child: const Column(
        children: <Widget>[
          IncomeWidget(),
          IncomeTable()
        ],
      ),
    );
  }
}

// Income form
class IncomeWidget extends StatefulWidget {
  const IncomeWidget({super.key});

  @override
  State<IncomeWidget> createState() => _IncomeWidgetState();
}

class _IncomeWidgetState extends State<IncomeWidget> {
  final TextEditingController _incomeController = TextEditingController();
  IncomePeriod _period = IncomePeriod.hour;
  int _kiwiSaver = 0;
  bool _studentLoan = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child:
              TextField(
                controller: _incomeController,
                decoration: const InputDecoration(
                  labelText: 'Income \$',
                ),
              ),
            ),
            DropdownButton<IncomePeriod>(
              value: _period,
              onChanged: (IncomePeriod? newValue) {
                setState(() {
                  _period = newValue!;
                });
              },
              items: IncomePeriod.values.map<DropdownMenuItem<IncomePeriod>>((IncomePeriod value) {
                return DropdownMenuItem<IncomePeriod>(
                  value: value,
                  child: Text(value.toString().split('.').last),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                final income = double.tryParse(_incomeController.text);
                if (income != null) {
                  Provider.of<IncomeViewModel>(context, listen: false).onCalculate(income, _period, _kiwiSaver, _studentLoan);
                }
              },
              child: const Text('Calculate'),
            ),
          ],
        ),
        Row(
          children: [
            DropdownButton<int>(
              value: _kiwiSaver,
              onChanged: (int? newValue) {
                setState(() {
                  _kiwiSaver = newValue!;
                });
              },
              items: List<int>.generate(11, (int index) => index).map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value%'),
                );
              }).toList(),
            ),
            Row(
              children: [
                const Text('Student Loan'),
                Checkbox(
                  value: _studentLoan,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _studentLoan = newValue!;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// Income table
class IncomeTable extends StatelessWidget {
  const IncomeTable({super.key});

  @override
  Widget build(BuildContext context) {
    final income = Provider.of<IncomeViewModel>(context).income;
    if (income == null) {
      return const SizedBox();
    }

    return DataTable(
      columns: const <DataColumn>[
        DataColumn(label: Text('')),
        DataColumn(label: Text('Hourly')),
        DataColumn(label: Text('Daily')),
        DataColumn(label: Text('Weekly')),
        DataColumn(label: Text('Fortnightly')),
        DataColumn(label: Text('Monthly')),
        DataColumn(label: Text('Yearly')),
      ],
      rows: <DataRow>[
        DataRow(
          cells: <DataCell>[
            const DataCell(Text('Gross')),
            DataCell(Text(Income.formatAsCurrency(income.grossHourly))),
            DataCell(Text(Income.formatAsCurrency(income.grossDaily))),
            DataCell(Text(Income.formatAsCurrency(income.grossWeekly))),
            DataCell(Text(Income.formatAsCurrency(income.grossFortnightly))),
            DataCell(Text(Income.formatAsCurrency(income.grossMonthly))),
            DataCell(Text(Income.formatAsCurrency(income.grossYearly))),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            const DataCell(Text('PAYE')),
            DataCell(Text(Income.formatAsCurrency(income.payeHourly))),
            DataCell(Text(Income.formatAsCurrency(income.payeDaily))),
            DataCell(Text(Income.formatAsCurrency(income.payeWeekly))),
            DataCell(Text(Income.formatAsCurrency(income.payeFortnightly))),
            DataCell(Text(Income.formatAsCurrency(income.payeMonthly))),
            DataCell(Text(Income.formatAsCurrency(income.payeYearly))),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            const DataCell(Text('ACC')),
            DataCell(Text(Income.formatAsCurrency(income.accHourly))),
            DataCell(Text(Income.formatAsCurrency(income.accDaily))),
            DataCell(Text(Income.formatAsCurrency(income.accWeekly))),
            DataCell(Text(Income.formatAsCurrency(income.accFortnightly))),
            DataCell(Text(Income.formatAsCurrency(income.accMonthly))),
            DataCell(Text(Income.formatAsCurrency(income.accYearly))),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            const DataCell(Text('KiwiSaver')),
            DataCell(Text(Income.formatAsCurrency(income.kiwiSaverHourly))),
            DataCell(Text(Income.formatAsCurrency(income.kiwiSaverDaily))),
            DataCell(Text(Income.formatAsCurrency(income.kiwiSaverWeekly))),
            DataCell(Text(Income.formatAsCurrency(income.kiwiSaverFortnightly))),
            DataCell(Text(Income.formatAsCurrency(income.kiwiSaverMonthly))),
            DataCell(Text(Income.formatAsCurrency(income.kiwiSaverYearly))),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            const DataCell(Text('Student Loan')),
            DataCell(Text(Income.formatAsCurrency(income.studentLoanHourly))),
            DataCell(Text(Income.formatAsCurrency(income.studentLoanDaily))),
            DataCell(Text(Income.formatAsCurrency(income.studentLoanWeekly))),
            DataCell(Text(Income.formatAsCurrency(income.studentLoanFortnightly))),
            DataCell(Text(Income.formatAsCurrency(income.studentLoanMonthly))),
            DataCell(Text(Income.formatAsCurrency(income.studentLoanYearly))),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            const DataCell(Text('Net')),
            DataCell(Text(Income.formatAsCurrency(income.netHourly))),
            DataCell(Text(Income.formatAsCurrency(income.netDaily))),
            DataCell(Text(Income.formatAsCurrency(income.netWeekly))),
            DataCell(Text(Income.formatAsCurrency(income.netFortnightly))),
            DataCell(Text(Income.formatAsCurrency(income.netMonthly))),
            DataCell(Text(Income.formatAsCurrency(income.netYearly))),
          ],
        ),
      ],
    );
  }
}