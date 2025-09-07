import 'package:flutter/material.dart';
import 'package:g2e/widgets/g2e_appbar.dart';

class FoodCalcPage extends StatefulWidget {
  const FoodCalcPage({super.key, required this.title});
  //For the Appbar
  final String title;
  //How the result of the calculation should be rendered
  static const TextStyle resultTextStyle = TextStyle(fontSize: 30);

  //Map for the options--internal identifier and the display text
  //for the food types
  static const Map<String, String> foodTypeOptions = {
    "canned_food": "Canned Food (anything in a sealed can)",
    "meat": "Meat (anything from animals)",
    "veg": "Vegetables (include fruit as well. Anything from plants. )",
  };
  //for the storage conditions
  static const Map<String, String> storageConditionOptions = {
    "cool_dry": "A cool, dry place",
    "hot_dry": "A really hot, but dry place",
    "cold_dry": "A really cold, but dry place",
    "cool_wet": "A cool, but humid / wet place",
    "hot_wet": "A really hot, really humid / wet place",
    "cold_wet": "A really cold, but humid / wet place (excluding ice)",
  };
  //Converts the above maps to flutter's DropdownMenuItems. Having the maps just makes things easier. 
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
  //these correspond to what the user inputs
  String? foodType;
  String? storageCondition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AidlinkAppbar(title: widget.title),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // the rest of it here goes as: 
          // --instruction--
          // --dropdown--
          // ---more inputs---
          // calculation result
          children: <Widget>[
            Text(
              "Please input the type of food! ",
              style: TextStyle(fontSize: 20),
            ),
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
            Text(
              "Please input the conditions of storage! ",
              style: TextStyle(fontSize: 20),
            ),
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
                    FoodCalcPage.storageConditionOptions,
                  ),
                  value: storageCondition,
                  onChanged: (value) {
                    setState(() {
                      storageCondition = value;
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  dropdownColor: Colors.grey[900],
                ),
              ),
            ),
            // Uses nested switch-case statements to account for every possibility in a scalable way. 
            switch (foodType) {
              "canned_food" => switch (storageCondition) {
                "cool_dry" => Text(
                  "It should last basically forever...",
                  style: FoodCalcPage.resultTextStyle,
                ),
                "cool_wet" => Text(
                  "It should last basically forever...",
                  style: FoodCalcPage.resultTextStyle,
                ),
                "hot_dry" => Text(
                  "It should last a bit, but check the can for swelling or damage",
                  style: FoodCalcPage.resultTextStyle,
                ),
                "hot_wet" => Text(
                  "It might last, but check the can for swelling or damage",
                  style: FoodCalcPage.resultTextStyle,
                ),
                "cold_wet" => Text(
                  "It should last, but check the can for damage",
                  style: FoodCalcPage.resultTextStyle,
                ),
                "cold_dry" => Text(
                  "It should last, but check the can for damage",
                  style: FoodCalcPage.resultTextStyle,
                ),
                _ => Text(
                  "Please input info! ",
                  style: FoodCalcPage.resultTextStyle,
                ),
              },
              "meat" => switch (storageCondition) {
                "cool_dry" => Text(
                  "Days to maybe a few weeks.",
                  style: FoodCalcPage.resultTextStyle,
                ),
                "cool_wet" => Text(
                  "Eat it ASAP. Water is not good. Maybe a few days. ",
                  style: FoodCalcPage.resultTextStyle,
                ),
                "hot_dry" => Text(
                  "MAYBE up to 1 day if you're lucky",
                  style: FoodCalcPage.resultTextStyle,
                ),
                "hot_wet" => Text(
                  "Literal hours. It should probably be thrown out. ",
                  style: FoodCalcPage.resultTextStyle,
                ),
                "cold_wet" => Text(
                  "Maybe a few weeks. ",
                  style: FoodCalcPage.resultTextStyle,
                ),
                "cold_dry" => Text(
                  "6-12 months, if you're lucky. Check before eating. ",
                  style: FoodCalcPage.resultTextStyle,
                ),
                _ => Text(
                  "Please input info! ",
                  style: FoodCalcPage.resultTextStyle,
                ),
              },
              "veg" => switch (storageCondition) {
                "cool_dry" => Text(
                  "A few moths, especially if it's ones with 'soft shells'",
                  style: FoodCalcPage.resultTextStyle,
                ),
                "cool_wet" => Text(
                  "1-3 weeks",
                  style: FoodCalcPage.resultTextStyle,
                ),
                "hot_dry" => Text(
                  "Maybe a few weeks/months, but less than cool conditions. ",
                  style: FoodCalcPage.resultTextStyle,
                ),
                "hot_wet" => Text(
                  "Maybe up to a week. ",
                  style: FoodCalcPage.resultTextStyle,
                ),
                "cold_wet" => Text(
                  "A few months. ",
                  style: FoodCalcPage.resultTextStyle,
                ),
                "cold_dry" => Text(
                  "6-8 months. ",
                  style: FoodCalcPage.resultTextStyle,
                ),
                _ => Text(
                  "Please input info! ",
                  style: FoodCalcPage.resultTextStyle,
                ),
              },
              _ => Text(
                "Please input info! ",
                style: FoodCalcPage.resultTextStyle,
              ),
            },
          ],
        ),
      ),
    );
  }
}
