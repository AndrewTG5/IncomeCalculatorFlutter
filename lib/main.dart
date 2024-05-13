import 'package:flutter/material.dart';
import 'package:income_calculator/income.dart';
import 'package:income_calculator/view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => IncomeViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Income Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  final Income? income = null;


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Column(
          children: <Widget>[
            IncomeWidget(),
            IncomeTable()
          ],
        ),
    );
  }
}

// Income input
// a widget with a text box, a drop down for the period, a drop down for the kiwisaver, a checkbox for the student loan, and a button to calculate the income
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
    );
  }
}

// Income table
// a widget that displays the income in a table
class IncomeTable extends StatelessWidget {
  const IncomeTable({super.key});

  @override
  Widget build(BuildContext context) {
    final income = Provider.of<IncomeViewModel>(context).income;
    if (income == null) {
      return const SizedBox();
    }

    return Table(
      children: <TableRow>[
        TableRow(
          children: <Widget>[
            const Text('Gross'),
            Text(income.grossHourly.toString()),
            Text(income.grossDaily.toString()),
            Text(income.grossWeekly.toString()),
            Text(income.grossFortnightly.toString()),
            Text(income.grossMonthly.toString()),
            Text(income.grossYearly.toString()),
          ],
        ),
        TableRow(
          children: <Widget>[
            const Text('PAYE'),
            Text(income.payeHourly.toString()),
            Text(income.payeDaily.toString()),
            Text(income.payeWeekly.toString()),
            Text(income.payeFortnightly.toString()),
            Text(income.payeMonthly.toString()),
            Text(income.payeYearly.toString()),
          ],
        ),
        TableRow(
          children: <Widget>[
            const Text('ACC'),
            Text(income.accHourly.toString()),
            Text(income.accDaily.toString()),
            Text(income.accWeekly.toString()),
            Text(income.accFortnightly.toString()),
            Text(income.accMonthly.toString()),
            Text(income.accYearly.toString()),
          ],
        ),
        TableRow(
          children: <Widget>[
            const Text('KiwiSaver'),
            Text(income.kiwiSaverHourly.toString()),
            Text(income.kiwiSaverDaily.toString()),
            Text(income.kiwiSaverWeekly.toString()),
            Text(income.kiwiSaverFortnightly.toString()),
            Text(income.kiwiSaverMonthly.toString()),
            Text(income.kiwiSaverYearly.toString()),
          ],
        ),
        TableRow(
          children: <Widget>[
            const Text('Student Loan'),
            Text(income.studentLoanHourly.toString()),
            Text(income.studentLoanDaily.toString()),
            Text(income.studentLoanWeekly.toString()),
            Text(income.studentLoanFortnightly.toString()),
            Text(income.studentLoanMonthly.toString()),
            Text(income.studentLoanYearly.toString()),
          ],
        ),
        TableRow(
          children: <Widget>[
            const Text('Net'),
            Text(income.netHourly.toString()),
            Text(income.netDaily.toString()),
            Text(income.netWeekly.toString()),
            Text(income.netFortnightly.toString()),
            Text(income.netMonthly.toString()),
            Text(income.netYearly.toString()),
          ],
        ),
      ],
    );
  }
}
