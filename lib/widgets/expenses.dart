// it should be StatefulWidget bc you have to update the UI every time you put expense

import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

import 'package:expense_tracker/models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  // You can create a type that has the same name as the class
  // You need to import the Dart file that defines the class
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(), // DateTime is not only a datatype but also a class
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(), // DateTime is not only a datatype but also a class
      category: Category.leisure,
    ),
  ];

  void _openAddExpenseOverlay() {
    // show built-in UI elements
    // you want to execute this method provided by Flutter through import 'package:flutter/material.dart';
    // context can be used as a value
    // you can think of this context object, this context value as some kind of metadata collection
    // an object full of metadata managed by Flutter that belongs to a specific widget.
    // So every widget has its own context object
    // You are required to pass context as a value by showModalBottomSheet
    // builder parameter takes a Function as a value whici returns a Widget
    // So here we can set up a function which gets a context value. And here I named this context parameters ctx,
    // so that I don't clash with this context.
    // ctx is different from context because it is the context of this modal bottom sheet that will be created
    // whereas context: context is the information object related to the Expenses widget
    showModalBottomSheet(
      // When useSafeArea is true, Flutter does not overlay the space for built-in features such as camera on the screen
      // Scaffold already takes this account so you don't have to add useSafeArea to it
      useSafeArea: true,
      // when isScrollControlled is true, ModalBottomSheet takes all space on the screen

      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

// This function takes Expense expense that should be removed from the list you managed
  void _removeExpense(Expense expense) {
    // To get where the deleted list item was located in the list, create a new variable
    // indexOf get the position of the value inside ()
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    // To show the next info message when the item is deleted just after the previous deleted item's info message is shown,
    // you need to clear the SnackBar.
    ScaffoldMessenger.of(context).clearSnackBars();
    // This is a special object you can use
    // You want to show an info message at the bottom when the list item is deleted
    // of method wants context and context is available in this class based on the state class
    // This gives us an insstance of this ScaffoldMessanger
    // "instance" refers to a specific occurrence or realization of a class.
    // In object-oriented programming (OOP), a class is a blueprint or template for creating objects.
    // An object is an instance of a class. It is a concrete manifestation or realization of the class blueprint.
    // An instance is another term for an object. When we say "creating an instance of a class" in Flutter (or any OOP language), we mean creating a new object based on the class blueprint
    // SnackBar allows you to popup a message for a few seconds
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          duration: const Duration(seconds: 3),
          content: const Text('Expense deleted.'),
          // This works as a button to undo the deleted list item
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              // You use setState to update the UI (to get the deleted list item back into where it was located in the list )
              setState(() {
                // insert method add an item in a list in a specific position
                // To get where the deleted list item was located in the list, create a new variable

                _registeredExpenses.insert(expenseIndex, expense);
              });
            },
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    // build method is executed every time the user rotate their phone
    // width becomes height and vice versa if you change portait mode to landscape mode
    final width = MediaQuery.of(context).size.width;

    // to show a fallback message
    Widget mainContent = const Center(
      child: Text('No expenses found'),
    );

// if _registeredExpenses is not empty, you wanna overwrite mainContent and store a different value in that variable
// The different value is expenseslist
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
        // placing a top bar
        // actions parameter wants a List of Widgets and this is used to display a button
        appBar: AppBar(
          title: const Text('Flutter expense tracker'),
          actions: [
            IconButton(
              // add _openAddExpenseOverlay, without () because we want to use it as a value for onPressed
              // so internally Flutter can execute this function whenever the button is pressed
              onPressed: _openAddExpenseOverlay,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        // Ternary operater  condition ? expIfTrue : expIfFalse
        body: width < 600
            ? Column(
                children: [
                  Chart(expenses: _registeredExpenses),
                  // You need Expanded widget to include ListView() inside of Column
                  Expanded(
                    child: mainContent,
                  ),
                ],
              )
            : Row(
                children: [
                  // You need to wrap Chart with Expanded because Chart takes as much space as poosible like Row() because of width: double.infinity, in Chart
                  Expanded(child: Chart(expenses: _registeredExpenses)),
                  // You need Expanded widget to include ListView() inside of Column
                  Expanded(
                    child: mainContent,
                  ),
                ],
              ));
  }
}
