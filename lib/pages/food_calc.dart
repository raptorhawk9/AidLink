import 'package:flutter/material.dart';
import 'package:g2e/widgets/g2e_appbar.dart';

class FoodCalcPage extends StatefulWidget {
  const FoodCalcPage({super.key, required this.title});
  final String title;

  @override
  State<FoodCalcPage> createState() => _FoodCalcPageState();
}

class _FoodCalcPageState extends State<FoodCalcPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: G2EAppbar(title: widget.title), 
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Food Calculation'),
          ],
        ),
      ),
    );
  }
}