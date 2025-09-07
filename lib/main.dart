import 'package:flutter/material.dart';
import 'package:g2e/pages/food_calc.dart';
import 'package:g2e/pages/home.dart';
import 'package:g2e/pages/map.dart';
import 'package:g2e/pages/navigation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() {
  setUrlStrategy(PathUrlStrategy());
  runApp(const AidLink());
}

class AidLink extends StatelessWidget {
  const AidLink({super.key});

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
        '/nav': (context) => NavigationPage(title: title),
      },
      title: 'AidLink',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 19, 36),
        ),
      ),
    );
  }
}
