import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';

// You need to create this file to keep StatefulWidget in expenses.dart lean
// So, a new widget is required
// The widget should be StatelessWidget bc it is just for outputing the list and doesn't manage internal data
class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onRemoveExpense,
  });

  final List<Expense> expenses;

  // For ExpensesList to accept _removeExpense function, you need to add a new argument
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    // Column() is not ideal when the list that is to be displayed might be very long
    // And, Column displays, behind the scenes, 1000 items when this class has the list and is displayed even though you need some
    // So you should not use Column() when you don't know the length of the list
    // Use ListView to get a scrollable list
    // ListView(children: [],) is not ideal because it still creates all items behind the scenes
    // So, use builder function
    // builder function build items of the list when they are only visible or about to be visible
    // itemBuilder parameter wants a Function as a value, and it wants the function that will get two input values
    // Those will be provided by Flutter and this function should then return a widget.
    // But here I'll go for an anonymous function and I'll get a context object and a index value automatically provided by Flutter (BuildContext, int)
    // then we must return the widget.
    // itemCount parameter defines how many list items will be rendered eventually.
    // And for that of course, I wanna pass the length of this ExpensesList as a value.
    // because we have two items in our list, this function (ctx, index) => Text('')  will be called twice.
    // Text(expenses[index].title), expenses is a List. index is a list index.
    // To access the title of the list item, add .title
    return ListView.builder(
      itemCount: expenses.length,
      // Dismissible allows you to swipe things
      //  this key mechanism exists to make widgets uniquely identifiable.
      // A key is needed to allow Flutter to uniquely identify a widget and the data that's associated with it.
      // And such a key can be created by using the built-in ValueKey constructor function.
      // ValueKey creates a key object that can be used as a value for this key parameter
      // key is needed for Dismissible to make sure that correct data is deleted
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(expenses[index]),
        // To set background color in Dismissible, you need to set Container()
        // because it has a color argument that sets color of Container
        // colorScheme is used for gettng hold of the color scheme you set up in main.dart
        // i.e., kColorScheme
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.5),
          margin: EdgeInsets.symmetric(
              // This allows you to set the margin you set in CardTheme in main.dart
              horizontal: Theme.of(context).cardTheme.margin!.horizontal),
        ),
        // onDismissed triggers a function when the item is swiped away
        // onDismissed wants a function as a value that takes a DismissedDirection as an input
        // That tells the swipe direction
        onDismissed: (direction) {
          onRemoveExpense(expenses[index]);
        },
        child: ExpenseItem(expense: expenses[index]),
      ),
    );
  }
}
