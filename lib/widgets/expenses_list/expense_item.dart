import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

// there won't be any internal data that would need to be managed so StatelessWidget
class ExpenseItem extends StatelessWidget {
  const ExpenseItem({super.key, required this.expense});

  final Expense expense;
  @override
  Widget build(BuildContext context) {
    // Card widget is used for styling
    return Card(
      // to adjust padding, refactor (wrap)it with padding
      child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // To apply the theme styling you set to this title, use Theme class
              // of method wants context and it is needed because Flutter wants to access the theme settings
              // .textTheme property gets access to all the text themes you set up
              Text(
                expense.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              // toStringAsFixed(2)  12.345 -> 12.34
              Row(
                children: [
                  // \$ outputs $
                  Text('\$${expense.amount.toStringAsFixed(2)}'),
                  // Spacer() can be used for Column or Row
                  // It takes all the remaining space it can take
                  const Spacer(),
                  // add Row widget to group date and category together
                  Row(children: [
                    // enum Category is keys
                    // categoryIcons takes map with keys being enum Category and values being Icons
                    // inside of [], you need to pass enum Category, so you need to add expense.category
                    // so you can dynamically generate icons
                    Icon(categoryIcons[expense.category]),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(expense.formattedDate),
                  ])
                ],
              ),
            ],
          )),
    );
  }
}
