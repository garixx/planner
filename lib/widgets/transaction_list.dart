import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../widgets/transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _transactions;
  final Function(String id) _deleteTransaction;

  TransactionList(this._transactions, this._deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return _transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraint) {
            return Column(
              children: [
                Text(
                  "No transactions added",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: constraint.maxHeight * 0.6,
                  child: Image.asset(
                    "assets/images/waiting.png",
                    fit: BoxFit.cover,
                  ),
                )
              ],
            );
          })
        : ListView(
            children: _transactions
                .map((tx) => TransactionItem(
                      key: ValueKey(tx.id),
                      transaction: tx,
                      deleteTransaction: _deleteTransaction,
                    ))
                .toList(),
          );
    // : ListView.builder(
    //     itemBuilder: (ctx, index) {
    //       return TransactionItem(
    //           key: Key("xxx"),
    //           transaction: _transactions[index],
    //           deleteTransaction: _deleteTransaction,
    //       );
    //     },
    //     itemCount: _transactions.length,
    //   );
  }
}
