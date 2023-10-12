import 'package:expenses_app/models/expense.dart';
import 'package:expenses_app/widgets/chart/chart.dart';
import 'package:expenses_app/widgets/expenses_list.dart';
import 'package:expenses_app/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [];

  //function to handle the plus button.. so the user can add new expenses..
  void _addOverlay() {
    showModalBottomSheet(
      useSafeArea:
          true, // to not hide the camera or the other stuff in the top of the mobile
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  //function to add a new expense to the expenses page.
  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  //This function is used to delete the expenses or undo the deleted ones.
  void _removeExpense(Expense expense) {
    final indexOfLastExpense = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    //to clear the message shows by the snackbar after doing another action.
    ScaffoldMessenger.of(context).clearSnackBars();

    // here we want show a bar that says undo if the user deleted a widget by mistake.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense Deleted!!'),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _registeredExpenses.insert(indexOfLastExpense, expense);
              });
            }),
      ),
    );
  }

  @override
  //This widget will be used if thse user didn't enter any expenses yet.
  Widget build(context) {
    //To know the width of the device we are using.
    final width = MediaQuery.of(context).size.width;
    Widget mainContet = const Center(
      child: Text(
        'No Expenses, add some :)',
        style: TextStyle(
          fontSize: 20,
          color: Color.fromARGB(255, 57, 7, 255),
        ),
      ),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContet = ExpensesList(
          expenses: _registeredExpenses, onRemoveExpense: _removeExpense);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Expensestracker'),
        actions: [
          IconButton(
            onPressed: _addOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < 600 //checking for the width to adjust the widgets
          ? Center(
              child: Column(
                children: [
                  Chart(expenses: _registeredExpenses),
                  Expanded(
                    child: mainContet,
                  )
                ],
              ),
            )
          : Row(
              children: [
                Expanded(
                  child: Chart(expenses: _registeredExpenses),
                ),
                Expanded(
                  child: mainContet,
                )
              ],
            ),
    );
  }
}
