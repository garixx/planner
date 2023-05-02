import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planner/models/transaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    required Key key,
    required this.transaction,
    required this.deleteTransaction,
  }) : super(key: key);

  final Transaction transaction;
  final Function(String id) deleteTransaction;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color _bgColor = Colors.pink;

  @override
  void initState() {
    const availableColors = [Colors.red, Colors.blue, Colors.black, Colors.purple];
    _bgColor = availableColors[Random().nextInt(4)];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(
                child: Text(
                    "\$${widget.transaction.amount.toStringAsFixed(2)}")),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(widget.transaction.date),
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        trailing: MediaQuery.of(context).size.width > 500
            ? OutlinedButton.icon(
          icon: const Icon(Icons.delete),
          label: const Text("Delete"),
          onPressed: () =>
              widget.deleteTransaction(widget.transaction.id),
        )
            : IconButton(
          icon: Icon(Icons.delete),
          color: Theme.of(context).colorScheme.error,
          onPressed: () =>
              widget.deleteTransaction(widget.transaction.id),
        ),
      ),
    );
  }
}
