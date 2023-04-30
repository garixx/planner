import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planner/models/transaction.dart';
import 'package:planner/widgets/chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> _recentTransactions;

  const Chart(this._recentTransactions);

  List<Map<String, Object>> get groupedTransactionsValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var total = 0.0;
      for (var i = 0; i < _recentTransactions.length; i++) {
        if (_recentTransactions[i].date.day == weekDay.day &&
            _recentTransactions[i].date.month == weekDay.month &&
            _recentTransactions[i].date.year == weekDay.year) {
          total = total + _recentTransactions[i].amount;
        }
      }

      //print("${DateFormat.E().format(weekDay)}, ${total}");
      return {
        "day": DateFormat.E().format(weekDay).substring(0, 1),
        "amount": total
      };
    }).reversed.toList();
  }

  double get maxSpending {
    return groupedTransactionsValues.fold(0.0, (sum, item) {
      return sum + (item["amount"] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactionsValues);
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionsValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  (data["day"] as String),
                  (data["amount"] as double),
                  maxSpending == 0.0
                      ? 0.0
                      : (data["amount"] as double) / maxSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
