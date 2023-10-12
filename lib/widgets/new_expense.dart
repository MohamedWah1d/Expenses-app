import 'dart:io'; //to know which platform we are using "IOS or andriod"

import 'package:expenses_app/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});
  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

DateTime? selectedDate;

class _NewExpenseState extends State<NewExpense> {
  //controller used to control the inputs the user enters.
  final _titlecontroller = TextEditingController();
  final _amountcontroller = TextEditingController();
  Category _selectedCategory = Category.leisure;

  //Function to show the date of the calender {year, month, day},
  //async and await is like waiting for a value in the future that will be used here
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firsDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firsDate,
      lastDate: now,
    );
    //Twe used setstate to change the value in the screen while we click on the button
    setState(() {
      selectedDate = pickedDate;
    });
  }

  //Function to show dialog of error messages bases on the platform we are using "andriod or ios"
  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        //cupartino is the styling family for the IOS devices.
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title, amount, date, category was entered'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title, amount, date, category was entered'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  //Checking if the given inputs are valid and are not empty
  void _submitExpenseData() {
    //tryparse will parse the text to double
    final enteramount = double.tryParse(_amountcontroller.text);
    final amountIsInValid = enteramount == null || enteramount <= 0;

    //trim removes all the spaces.
    if (_titlecontroller.text.trim().isEmpty ||
        amountIsInValid ||
        selectedDate == null) {
      //error messege
      _showDialog();
      return;
    }
    widget.onAddExpense(
      Expense(
          title: _titlecontroller.text,
          amount: enteramount,
          date: selectedDate!,
          category: _selectedCategory),
    );
    Navigator.pop(context);
  }

  //To delete the value inside the controller when its done.
  @override
  void dispose() {
    _titlecontroller.dispose();
    _amountcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //To make sure that we can access the other elements of the input user space, and it's
    //not hidden by the keyboard.
    final keyBoard = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (ctx, constraints) {
        //getting the maximum width of the screen.
        final width = constraints.maxWidth;
        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 48, 16, keyBoard + 16),
              child: Column(
                children: [
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _titlecontroller,
                            maxLength: 60,
                            decoration: const InputDecoration(
                              label: Text('Title'),
                              hintText: 'Enter the title',
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _amountcontroller,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              label: Text('Amount'),
                              prefixText: '\$',
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      controller: _titlecontroller,
                      maxLength: 60,
                      decoration: const InputDecoration(
                        label: Text('Title'),
                        hintText: 'Enter the title',
                      ),
                    ),
                  if (width >= 600)
                    Row(
                      children: [
                        DropdownButton(
                            value: _selectedCategory,
                            items: Category.values
                                .map(
                                  (category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(
                                      category.name.toUpperCase(),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                _selectedCategory = value;
                              });
                            }),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                selectedDate == null
                                    ? 'No date selected' // the '!' here to force dart that the value inside the variable won't be null!
                                    : formatter.format(selectedDate!),
                              ),
                              IconButton(
                                onPressed: _presentDatePicker,
                                icon: const Icon(Icons.calendar_month),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _amountcontroller,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              label: Text('Amount'),
                              prefixText: '\$',
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                selectedDate == null
                                    ? 'No date selected' // the '!' here to force dart that the value inside the variable won't be null!
                                    : formatter.format(selectedDate!),
                              ),
                              IconButton(
                                onPressed: _presentDatePicker,
                                icon: const Icon(Icons.calendar_month),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 16,
                  ),
                  if (width >= 600)
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            _submitExpenseData();
                          },
                          child: const Text('Save Expense'),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        DropdownButton(
                            value: _selectedCategory,
                            items: Category.values
                                .map(
                                  (category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(
                                      category.name.toUpperCase(),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                _selectedCategory = value;
                              });
                            }),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            _submitExpenseData();
                          },
                          child: const Text('Save Expense'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
