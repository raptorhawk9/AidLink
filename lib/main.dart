import 'package:flutter/material.dart';
import 'package:g2e/pages/food_calc.dart';
import 'package:g2e/pages/home.dart';
import 'package:g2e/pages/map.dart';

void main() {
  runApp(const AidLink());
}

class AidLink extends StatelessWidget {
  const AidLink({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String title = "AidLink";
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      initialRoute: "/",
      routes: {
        '/': (context) => HomePage(title: title),  
        '/food-calc': (context) => FoodCalcPage(title: title), 
        '/map': (context) => MapPage(title: title),
      },
      title: 'AidLink',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 16, 83, 21)),
      ),
    );
  }
}