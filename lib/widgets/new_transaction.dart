import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  void Function(String title, double amount) addTx;

  NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();

  void _submitFata() {
    final enteredTitle = titleController.text;
    final enteredAmount = double.tryParse(amountController.text) ?? -1;
    if(enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    }
    widget.addTx(enteredTitle, enteredAmount);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Title"),
              controller: titleController,
              keyboardType: TextInputType.text,
              onSubmitted: (_) => _submitFata(),
            ),
            TextField(
              decoration: InputDecoration(labelText: "Amount"),
              controller: amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (_) => _submitFata(),
            ),
            ElevatedButton(
              onPressed: _submitFata,
              //style: ElevatedButton.styleFrom(primary: Colors.black)
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.black),
                //backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              child: const Text("Add transaction"),
            ),
          ],
        ),
      ),
    );
  }
}
