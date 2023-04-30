import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planner/widgets/adaptive_button.dart';

class NewTransaction extends StatefulWidget {
  void Function(String title, double amount, DateTime dateTime) addTx;

  NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedTime;

  void _submitFata() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.tryParse(_amountController.text) ?? -1;
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedTime == null) {
      return;
    }
    widget.addTx(enteredTitle, enteredAmount, _selectedTime!);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedTime = pickedDate;
      });
    });
    print("...");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Title"),
                controller: _titleController,
                keyboardType: TextInputType.text,
                onSubmitted: (_) => _submitFata(),
              ),
              TextField(
                decoration: InputDecoration(labelText: "Amount"),
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => _submitFata(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                        child: Text(_selectedTime == null
                            ? "No Date Chosen!"
                            : "Selected date: ${DateFormat.yMd().format(_selectedTime!)} ")),
                    AdaptiveButton("Choosee Date", _presentDatePicker),
                  ],
                ),
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
      ),
    );
  }
}
