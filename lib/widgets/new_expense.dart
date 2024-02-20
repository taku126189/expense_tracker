import 'package:flutter/material.dart';

import 'package:expense_tracker/models/expense.dart';

// this needs to manage internal state so StatefulWidget
// showModalBottomSheet() builder parameter returns a Widget so this file is needed for it
class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

// this stores a Function as a value and provides an expense value
// onAddExpense will contain a function taht should be excuted when a certain event occurs
  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  // You can use TextEditingController(); but here's an alternative way
  // This should be empty because initially nothing has been entered.
  // var _enteredTitle = '';

  // // onChnaged parameter wants a function that will receive a String value
  // // that String value will be the value entered into the TextField
  // // This function will receive String inputValue
  // void _saveTitleInput(String inputValue) {
  //   // We don't need to wrap this with set state here because I'm actually not using entered value anywhere
  //   // in my UI code. So the UI doesn't need to update just because I'm storing the value entered by the user in some variable.
  //   _enteredTitle = inputValue;
  // }
  // To call the function,
  // TextField(onChanged: _saveTitleInput)

// TextEditingController(); passes a value to TextField
// When you create a TextEditingController here you also have to tell Flutter to delete that controller when the widget is not needed anymore.
  final _titleController = TextEditingController();

  final _amountController = TextEditingController();
// so you need to add dispose method so the device memory is not taken up by all unnecessary controllers
// When the method inside {} is called, the dispose method is automatically executed and delete the data
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

// This variable is used for storing date the user selected
// This should be optional because the user might not select the date
  DateTime? _selectedDate;

// This function was made for using showDatePicker and showing Datepicker
  void _presentDatePicker() async {
    final now = DateTime.now();
    // now.month means the same month as now
    final firstDate = DateTime(
      now.year - 1,
      now.month,
      now.day,
    );

// showDatePicker( returns Future
// Future is an object that wraps a value, which you don't have yet but which you will have in the future.
// When showDatePicker is executed by Flutter, it opens this date picker and shows it on the screen.
// But of course, no date has been picked yet. That will only happen in the future.
// Therefore, Flutter internally basically memorizes that in the future some value will be picked here and
// it allows you to register a function that should be executed in that future once that value is available.
// And that function can be registered by calling a method on that object, on that future object that is returned by show date picker.
// Future gives you a then method.
// You can call it to which you can pass a function that will get the value
//  ).then((value) => null);
// Or you can use async and await. Put async between () and {} and await before Future
// So you can't use async await here in the build method for your widgets but you can use it whenever you get such a future value.
// the await keyword internally tells Flutter that the value won't be available immediately
// but it is in the future, so Flutter will wiat for that value before it stores it in that variable (pickedDate)
// But, Flutter will exepcute the next line after it gets that value
// You want to store the date the user selected, so you make _selectedDate variable

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    // You use setState() that tells Flutter to re-excute the build method
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  // This is triggered when 'Save Expense' button is pressed
  // inside of submitExpenseData, we now have to validate the data selected by the user.
  void _submitExpenseData() {
    // double.tryParse converts String into double. It can be int.tyrParse
    // if it cannot convert it, it returns null
    // e.g., double.tryParse('Hello') returns null
    final enteredAmount = double.tryParse(_amountController.text);
    // && and operator, || or operator. if enteredAmount is null or less than or equal to 0, it returns true

    final amountInvalid = enteredAmount == null || enteredAmount <= 0;

    // .text shows String the user is editing
    // .trim method removes excess white space
    // isEmpty property can be called on String and List
    // This if statement can be true if we have an empty title or just a bunch of blanks.
    // If it's true, show an error message
    // if amountInvalid is true, show an error message
    if (_titleController.text.trim().isEmpty ||
        amountInvalid ||
        _selectedDate == null) {
      // builder arugment wants a function that takes some context as an input and returns a widget as a value
      // the widget in the builder argument is content of the popup
      // So here we get this context provided by Flutter automatically when it executes this builder method.
      // And the widget I want to return here will be one of the built-in dialogue widgets.
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
            title: const Text('Invalid input'),
            content: const Text('Enter vaild data'),
            actions: [
              TextButton(
                onPressed: () {
                  //  Navigator.pop(); closes the window
                  // pop method wants context, in this case, the context connected to this dialogue.
                  // so the ctx value is passed in here
                  Navigator.pop(ctx);
                },
                child: const Text('Okay'),
              ),
            ]),
      );
      // By placing return here, the code from here onwards won't be executed
      return;
    }
// widget is available in the state class and it access to the connected widget class

    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    // This closes ModalOverlay after adding new expense
    Navigator.pop(context);
  }

  Category _selectedCategory = Category.leisure;

  @override
  Widget build(BuildContext context) {
    // stores how much space is taken up by the keyboard from the bottom (in the landscape mode, some elements of modal bottom sheet is hidden behind the keyboard)
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    // constraints.maxHeight, constraints.minHeight, constraints.maxWidth, constraints.minWidth are used for you to grasp available space
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return SizedBox(
          // Without this, modal bottom sheet does not go up to the top. double.infinity takes all the space avaialble as long as the parent allows
          height: double.infinity,
          child: SingleChildScrollView(
            // You need padding around text fields
            child: Padding(
              // padding: const EdgeInsets.all(16),
              // In order not to get some elements hidden behind the keyboard, adjust the padding
              padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),
              child: Column(
                children: [
                  // if width is greater than or equal to 600, two TextFields are aligned in Row
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _titleController,
                            maxLength: 50,
                            decoration: const InputDecoration(
                              hintText: 'Enter title',
                              label: Text('Title'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Enter amount',
                              prefixText: '\$ ',
                              label: Text('Amount'),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      // onChanged allows us to register a function that will be triggered when the value in the TextField changes
                      // onChnaged parameter wants a function that will receive a String value and
                      // that String value will be the value entered into the TextField
                      controller: _titleController,

                      maxLength: 50,
                      decoration: const InputDecoration(
                        hintText: 'Enter title',
                        label: Text('Title'),
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
                            setState(() {
                              if (value == null) {
                                return;
                              }
                              _selectedCategory = value;
                            });
                          },
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _selectedDate == null
                                    ? 'No date selected'
                                    : formatter.format(_selectedDate!),
                              ),
                              IconButton(
                                onPressed: _presentDatePicker,
                                icon: const Icon(
                                  Icons.calendar_month,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        // To use Expanded inside below, you need to wrap TextField with Expanded
                        // by doing this, TextField takes all remaining spaces between the following widget
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Enter amount',
                              prefixText: '\$ ',
                              label: Text('Amount'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        // Using Row inside Row causes a problem so use Expanded
                        // because Expanded takes all space between widgets
                        Expanded(
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.end places children widgets at the end
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                // format method wants DateTime, not optional Datetime]
                                // So, force Dart to make the variable null using ! mark that means it cannot be null
                                // It cannot be null because the condition (_selectedDate == null) is set
                                _selectedDate == null
                                    ? 'No date selected'
                                    : formatter.format(_selectedDate!),
                              ),
                              IconButton(
                                onPressed: _presentDatePicker,
                                icon: const Icon(
                                  Icons.calendar_month,
                                ),
                              ),
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
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            // Navigator class
                            // pop method wants the current context as an argument
                            // the context value is in this build method (i.e., Widget build(BuildContext context) {)
                            // So this is passed by Flutter and and we have to kind of forward it to the pop method.
                            // And pop simply removes this overlay from the screen.
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: _submitExpenseData,
                          child: const Text('Save Expense'),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        // .values propety gives you all values in the enum
                        // item parameter wants a List but Category is enum so you need to convert
                        // map wants a function that will be executed automatically by Dart for every list item
                        // the input value passed by Dart is category that shows every item in the enum
                        // You want to return DropdownMenuItem
                        // child paramter wants a Widget that will be shown on the screen
                        // .map is Iterable so you need to convert it to List which item parameter wants
                        DropdownButton(
                          // By adding value parameter, the dropdown shows the value selected, not just empty one
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  // value parameter is needed for storing the value the user selected
                                  // this value is passed to onChanged
                                  // By doing this, the enum category value is mapped to Dropdownlist item
                                  value: category,
                                  child: Text(
                                    // name property gets the name of enum
                                    category.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              // the user might select anything in DropDown
                              // so by adding if statement beforehand, _selectedCategory = value; can be executed only when value is not null
                              if (value == null) {
                                return;
                              }
                              // This stores selected category and updates the state whenever it changes
                              _selectedCategory = value;
                            });
                          },
                        ),
                        const Spacer(),

                        TextButton(
                          onPressed: () {
                            // Navigator class
                            // pop method wants the current context as an argument
                            // the context value is in this build method (i.e., Widget build(BuildContext context) {)
                            // So this is passed by Flutter and and we have to kind of forward it to the pop method.
                            // And pop simply removes this overlay from the screen.
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: _submitExpenseData,
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
    // Wrap Padding() with SingleChildScrollView so a single widget can be scrolled
  }
}
