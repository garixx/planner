import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:planner/widgets/chart.dart';
import 'package:uuid/uuid.dart';

import '../models/transaction.dart';
import '../widgets/new_transaction.dart';
import '../widgets/transaction_list.dart';
import '../widgets/chart.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized(); // save check before restrict orientations
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp
  // ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        errorColor: Colors.redAccent,
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: "Quicksand",
        textTheme: ThemeData.light(useMaterial3: true).textTheme.copyWith(
                titleMedium: TextStyle(
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

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  bool _showChart = false;
  final _uuid = Uuid();
  final List<Transaction> _transactions2 = [];
  final List<Transaction> _transactions = [
    Transaction(
        id: Uuid().v4(),
        title: "New Choose 1",
        amount: 4.50789,
        date: DateTime.now().subtract(Duration(days: 3))),
    Transaction(
        id: Uuid().v4(),
        title: "Old  Choose 1",
        amount: 3.27,
        date: DateTime.now().subtract(Duration(days: 5))),
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
        date: DateTime.now().subtract(Duration(days: 5))),
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
        date: DateTime.now().subtract(Duration(days: 5))),
    Transaction(
        id: Uuid().v4(),
        title: "Current Choose 3",
        amount: 14.50,
        date: DateTime.now()),
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Transaction> get _recentTransactions {
    return _transactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 5)));
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime dateTime) {
    final newTx = Transaction(
        id: _uuid.v4(), title: title, amount: amount, date: dateTime);
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
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: NewTransaction(_addNewTransaction),
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tx) => tx.id == id);
    });
  }

  Widget _buildLandscapeContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Show chart",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Switch.adaptive(
          value: _showChart,
          onChanged: (bool value) {
            setState(() {
              _showChart = value;
            });
          },
        ),
      ],
    );
  }

  List<Widget> _buildPortraitContent(MediaQueryData mediaQueryData,
      AppBar androidNavBar, Container txListWidget) {
    return [
      Container(
        height: (mediaQueryData.size.height -
                mediaQueryData.padding.top -
                androidNavBar.preferredSize.height) *
            0.3,
        width: double.infinity,
        child: Chart(_recentTransactions),
      ),
      txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final isLandscape = mediaQueryData.orientation == Orientation.landscape;
    final androidNavBar = AppBar(
      title: const Text(
        "Personal Expenses",
      ),
      actions: [
        IconButton(
            onPressed: () => _startAddNewTransaction(context),
            icon: Icon(Icons.add)),
      ],
    );
    final cupertinoNavBar = CupertinoNavigationBar(
      middle: const Text(
        "Personal Expenses",
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
              onTap: () => _startAddNewTransaction(context),
              child: Icon(CupertinoIcons.add)),
        ],
      ),
    );

    final txListWidget = Container(
        height:
            (mediaQueryData.size.height - androidNavBar.preferredSize.height) *
                0.7,
        child: TransactionList(_transactions, _deleteTransaction));
    var pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape) _buildLandscapeContent(),
            if (!isLandscape) ..._buildPortraitContent(mediaQueryData, androidNavBar, txListWidget),
            if (isLandscape)
              _showChart
                  ? Container(
                      height: (mediaQueryData.size.height -
                              mediaQueryData.padding.top -
                              androidNavBar.preferredSize.height) *
                          0.7,
                      width: double.infinity,
                      child: Chart(_recentTransactions),
                    )
                  : txListWidget,
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: cupertinoNavBar,
          )
        : Scaffold(
            appBar: androidNavBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
