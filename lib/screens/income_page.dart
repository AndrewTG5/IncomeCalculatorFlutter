import 'package:flutter/material.dart';
import 'package:income_calculator/data/income.dart';
import 'package:income_calculator/utils.dart';
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
      child: const SingleChildScrollView(
        child: Column(
          children: <Widget>[
            IncomeForm(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: IncomeTable()
            ),
          ],
        ),
      ),
    );
  }
}

class IncomeForm extends StatefulWidget {
  const IncomeForm({super.key});

  @override
  State<IncomeForm> createState() => _IncomeFormState();
}

class _IncomeFormState extends State<IncomeForm> {
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
            Row(
              children: [
                const Text('KiwiSaver'),
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
              ],
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
            DataCell(Text(formatAsCurrency(income.grossHourly))),
            DataCell(Text(formatAsCurrency(income.grossDaily))),
            DataCell(Text(formatAsCurrency(income.grossWeekly))),
            DataCell(Text(formatAsCurrency(income.grossFortnightly))),
            DataCell(Text(formatAsCurrency(income.grossMonthly))),
            DataCell(Text(formatAsCurrency(income.grossYearly))),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            const DataCell(Text('PAYE')),
            DataCell(Text(formatAsCurrency(income.payeHourly))),
            DataCell(Text(formatAsCurrency(income.payeDaily))),
            DataCell(Text(formatAsCurrency(income.payeWeekly))),
            DataCell(Text(formatAsCurrency(income.payeFortnightly))),
            DataCell(Text(formatAsCurrency(income.payeMonthly))),
            DataCell(Text(formatAsCurrency(income.payeYearly))),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            const DataCell(Text('ACC')),
            DataCell(Text(formatAsCurrency(income.accHourly))),
            DataCell(Text(formatAsCurrency(income.accDaily))),
            DataCell(Text(formatAsCurrency(income.accWeekly))),
            DataCell(Text(formatAsCurrency(income.accFortnightly))),
            DataCell(Text(formatAsCurrency(income.accMonthly))),
            DataCell(Text(formatAsCurrency(income.accYearly))),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            const DataCell(Text('KiwiSaver')),
            DataCell(Text(formatAsCurrency(income.kiwiSaverHourly))),
            DataCell(Text(formatAsCurrency(income.kiwiSaverDaily))),
            DataCell(Text(formatAsCurrency(income.kiwiSaverWeekly))),
            DataCell(Text(formatAsCurrency(income.kiwiSaverFortnightly))),
            DataCell(Text(formatAsCurrency(income.kiwiSaverMonthly))),
            DataCell(Text(formatAsCurrency(income.kiwiSaverYearly))),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            const DataCell(Text('Student Loan')),
            DataCell(Text(formatAsCurrency(income.studentLoanHourly))),
            DataCell(Text(formatAsCurrency(income.studentLoanDaily))),
            DataCell(Text(formatAsCurrency(income.studentLoanWeekly))),
            DataCell(Text(formatAsCurrency(income.studentLoanFortnightly))),
            DataCell(Text(formatAsCurrency(income.studentLoanMonthly))),
            DataCell(Text(formatAsCurrency(income.studentLoanYearly))),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            const DataCell(Text('Net')),
            DataCell(Text(formatAsCurrency(income.netHourly))),
            DataCell(Text(formatAsCurrency(income.netDaily))),
            DataCell(Text(formatAsCurrency(income.netWeekly))),
            DataCell(Text(formatAsCurrency(income.netFortnightly))),
            DataCell(Text(formatAsCurrency(income.netMonthly))),
            DataCell(Text(formatAsCurrency(income.netYearly))),
          ],
        ),
      ],
    );
  }
}