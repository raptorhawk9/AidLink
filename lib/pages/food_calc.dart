import 'package:flutter/material.dart';
import 'package:g2e/widgets/g2e_appbar.dart';

class FoodCalcPage extends StatefulWidget {
  const FoodCalcPage({super.key, required this.title});
  final String title;

  static const List<String> foodTypeOptions = [
    "  Canned Food",
    "  Meat",
    "  Vegetables",
    "  Processed Food",
  ];

  List<DropdownMenuItem> listToDropdownOptions(List<String> list) {
    return list.map((String option) {
      return DropdownMenuItem<String>(value: option, child: Text(option));
    }).toList();
  }

  @override
  State<FoodCalcPage> createState() => _FoodCalcPageState();
}

class _FoodCalcPageState extends State<FoodCalcPage> {
  String? foodType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AidlinkAppbar(title: widget.title),
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
            DropdownButton(
              items: widget.listToDropdownOptions(FoodCalcPage.foodTypeOptions),
              value: foodType,
              onChanged: (value) {
                setState(() {
                  foodType = value;
                });
              },
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
      ),
    );
  }
}
