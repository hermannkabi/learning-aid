import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learning_aid/screens/add_game.dart';
import 'package:learning_aid/screens/home.dart';
import 'package:learning_aid/screens/loading.dart';
import 'package:learning_aid/screens/play.dart';
import 'screens/welcome.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/":(context)=>Loading(),
        "/home":(context)=>Home(),
        "/welcome":(context)=>WelcomeScreen(),
        "/add":(context)=>AddGame(),
        "/play":(context)=>Play(),
      },
      initialRoute: "/",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          subtitle1: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 47, fontWeight: FontWeight.w500)),
          subtitle2: GoogleFonts.montserrat(textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 24)),
          button: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 21, fontWeight: FontWeight.bold,)),
          headline1: GoogleFonts.lato(textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 29)),
          bodyText2: GoogleFonts.aBeeZee(textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 24)),
          bodyText1: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 21)),
        ),
      ),
    );
  }
}

