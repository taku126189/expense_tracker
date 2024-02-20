// to describe which kind of structure an expense should have
// so we create a class
// a single expense is made up with several data points
// so we want to group together

// import uuid package
// This gives us a class which you can instantiate to get an object
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

// DateFormat class is provided by intl package
// yMd constructor function
// store the value of calling this constructor functio in a final variable
// yMd constructor function defines how the date will be formatted.
final formatter = DateFormat.yMd();

// It is just a utility object so you define this outside of Expense class
// By doing so, you can this anywhere to generate an unique id
// Use const so that uuid variable cannot be reassigned
const uuid = Uuid();

// you can define expense category like final String category; so you can create a new object like Expense(category: 'leisure')
// but this is prone to a typo and with the typo, you cannot get any error message bc it is a String
// so, using String is not optimal
// so you want to set the condition that you have to use one of several allowed values
// Even though '' isn't used here, Dart recognises these values as String
enum Category { food, travel, leisure, work }

// categoryIcons is map
const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

class Expense {
  final String id; // to identify expenses
  final String title; // expense title
  final double amount; // expense amount
  final DateTime date;
  final Category category;

// getter is used to format date because it takes date and generates something new based on it
  String get formattedDate {
    // you can call the format method and then pass your date to it.
    // And this will return a string containing the formatted version of that date,
    return formatter.format(date);
  }

  Expense({
    // id is not a required parameter because you will create unique id whenevrer new expense is created
    // To do so, uuid is used
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    // initilizer lists can be used to initialize class properties (like id) with values that are NOT received
    // as constructor function arguments
    // after :, you can initialize the properties of this class
    // id = means when this object (id) is created, the value uuid.v4 is the initial value
    // v4 generates String value
    // so whenever this Expense class is initialized, unique String value is assigned to variable id
  }) : id = uuid.v4();
}

// In the chart, every category should be summed up
class ExpenseBucket {
  final Category category;
  // This variable is needed for including multiple expenses
  final List<Expense> expenses;

  ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  // By adding the name of the extra constructor you wanna add to this class
  // after the name of the class
  // This is how you can add an additional constructor function to your class
  // allExpenses is a parameter accepted by the constructor function
  // The idea to add this addtional constructor function is that we add some logic to this constructor function
  // to go through all the expenses we got and then filter out the ones that belong to this category
  // That is, this is a utility constructor function that takes care of filtering out the expenses that belong to a specific category
  // You have to add an initializer list by adding a colon
  // where method is available on List to filter a list
  // false = if you wanna keep the list, true = you wanna get rid of it
  // expense.category == expense you are evaluateing has a category that is equal to this.category
  // So if the expesne im currently looking at has the category i wanna set for this ExpenseBucket,
  // i wanna keep that expense in the list of expenses that is stored in this bucket
  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  // This is an utility getter to sum all expenses up
  double get totalExpenses {
    double sum = 0;

    // This loop goes through all list item
    for (final expense in expenses) {
      // sum = sum + expense.amount;
      // The below is the shorthanded version
      sum += expense.amount;
    }

    return sum;
  }
}
