
import 'package:flutter/material.dart';
import 'package:g2e/widgets/g2e_appbar.dart';

class FoodCalcPage extends StatefulWidget {
  const FoodCalcPage({super.key, required this.title});
  final String title;

  static const Map<String, String> foodTypeOptions = {
    "canned_food": "Canned Food (anything in a sealed can)", 
    "meat": "Meat (anything from animals)",
    "veg": "Vegetables (include fruit as well. Anything from plants. )",
    "pros_food": "Processed Food (anything that's been modified or added. )",
  };

  List<DropdownMenuItem> mapToDropdownOptions(Map<String, String> map) {
    return map.entries.map((entry) {
      return DropdownMenuItem<String>(
        value: entry.key,
        child: Text(
          entry.value,
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
      );
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
            Text("Please input the type of food! ", style: TextStyle(fontSize: 20),), 
            //For the type of food
            Card(
              color: Colors.grey[900],
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: DropdownButton(
                  items: widget.mapToDropdownOptions(
                    FoodCalcPage.foodTypeOptions,
                  ),
                  value: foodType,
                  onChanged: (value) {
                    setState(() {
                      foodType = value;
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  dropdownColor: Colors.grey[900],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
