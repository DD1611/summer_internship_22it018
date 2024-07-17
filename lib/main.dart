import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'setup_page.dart';

void main() {
  runApp(CricketScoringApp());
}

class CricketScoringApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cricket Scoring App',
      theme: ThemeData(
        primaryColor: Colors.lightBlue,
        hintColor: Colors.orangeAccent,
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: Colors.black87,
          displayColor: Colors.black87,
        ),
        appBarTheme: AppBarTheme(
          color: Colors.lightBlue,
          elevation: 0,
          toolbarTextStyle: GoogleFonts.robotoTextTheme(
            Theme.of(context).textTheme,
          ).apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ).bodyText2,
          titleTextStyle: GoogleFonts.robotoTextTheme(
            Theme.of(context).textTheme,
          ).apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ).headline6,
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.lightBlue,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: SetupPage(),
    );
  }
}
