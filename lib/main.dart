import 'package:expense_tracker/widgets/expenses.dart';
import 'package:flutter/material.dart';
// This enables controlling screen orientation
// import 'package:flutter/services.dart';

// naming convention k means that you set up global variables
var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 36, 105, 224),
);

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 5, 99, 125),
);

void main() {
  // // This line of code ensures that the Flutter framework is fully initialized before proceeding with the rest of the application setup.
  // // By ensuring that the Flutter framework is initialized first, the app can safely set up and run with the desired configurations without potential issues related to uninitialized framework features.
  // WidgetsFlutterBinding.ensureInitialized();
  // // This locks the app's screen orientation
  // // Asynchronous Operation: SystemChrome.setPreferredOrientations([...]) is an asynchronous operation. It returns a Future that completes when the preferred orientations are set.
  // // Chaining Operations: The then method is used to chain operations to be executed after the asynchronous operation completes
  // // It allows you to specify a callback function (i.e., (value) {...}) (often referred to as an "on success" callback) that will be executed when the Future completes successfully.
  // // In the provided code, after setting the preferred screen orientations, the then method is used to specify the runApp() function with the MaterialApp widget and its configurations. This ensures that the app is run only after the preferred screen orientations are set successfully.
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  // ]).then((value) {runApp(MaterialApp...))});
  // I commented out the above because I need landscape mode for this app
  runApp(
    MaterialApp(
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        cardTheme: const CardTheme().copyWith(
          color: kDarkColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: kDarkColorScheme.primaryContainer,
              foregroundColor: kDarkColorScheme.onPrimaryContainer),
        ),
      ),
      // copyWith overrides the selected setting
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.primaryContainer,
        ),
        cardTheme: const CardTheme().copyWith(
          color: kColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        // ElevatedButtonThemeData doesn't have copyWith, so use style
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primaryContainer,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                fontWeight:
                    FontWeight.bold, // the appbar title is no longer bold
                color: kColorScheme.onSecondaryContainer,
                fontSize: 16,
              ),
            ),
      ),
      // ThemeMode.system takes a look at which mode the user selected
      // This is default so you don't need to set it up yourself
      // themeMode: ThemeMode.system,
      home: const Expenses(),
    ),
  );
}
