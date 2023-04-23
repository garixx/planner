import 'package:flutter/material.dart';
import 'package:planner/widgets/chart.dart';
import 'package:uuid/uuid.dart';

import '../models/transaction.dart';
import '../widgets/new_transaction.dart';
import '../widgets/transaction_list.dart';
import '../widgets/chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: "Quicksand",
        textTheme: ThemeData.light(useMaterial3: true).textTheme.copyWith(titleMedium: TextStyle(
          fontFamily: "OpenSans",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        )),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: "OpenSans",
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _uuid = Uuid();
  final List<Transaction> _transactions = [];
  final List<Transaction> _transactions2 = [
    Transaction(
        id: Uuid().v4(),
        title: "New Choose 1",
        amount: 4.50789,
        date: DateTime.now().subtract(Duration(days: 3))),
    Transaction(
        id: Uuid().v4(),
        title: "Old  Choose 1",
        amount: 3.27,
        date: DateTime.now().subtract(Duration(days: 7))),
    Transaction(
        id: Uuid().v4(),
        title: "Current Choose 1",
        amount: 14.50,
        date: DateTime.now()),
    Transaction(
        id: Uuid().v4(),
        title: "New Choose 2",
        amount: 4.99,
        date: DateTime.now().subtract(Duration(days: 3))),
    Transaction(
        id: Uuid().v4(),
        title: "Old  Choose 2",
        amount: 3.27,
        date: DateTime.now().subtract(Duration(days: 7))),
    Transaction(
        id: Uuid().v4(),
        title: "Current Choose 2",
        amount: 14.50789,
        date: DateTime.now()),
    Transaction(
        id: Uuid().v4(),
        title: "New Choose 3",
        amount: 4.99,
        date: DateTime.now().subtract(Duration(days: 3))),
    Transaction(
        id: Uuid().v4(),
        title: "Old  Choose 3",
        amount: 3.27,
        date: DateTime.now().subtract(Duration(days: 7))),
    Transaction(
        id: Uuid().v4(),
        title: "Current Choose 3",
        amount: 14.50,
        date: DateTime.now()),
  ];

  List<Transaction> get _recentTransactions {
    return _transactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String title, double amount) {
    final newTx = Transaction(
        id: _uuid.v4(), title: title, amount: amount, date: DateTime.now());
    setState(() {
      _transactions.add(newTx);
      print("Added: ${newTx.id} ${newTx.title} ${newTx.amount} ${newTx.date}");
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (bCtx) {
          return GestureDetector(
            child: NewTransaction(_addNewTransaction),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Personal Expenses",
        ),
        actions: [
          IconButton(
              onPressed: () => _startAddNewTransaction(context),
              icon: Icon(Icons.add)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Chart(_recentTransactions),
            ),
            //UserTransactions(),
            TransactionList(_transactions),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
