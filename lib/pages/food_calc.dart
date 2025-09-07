
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

  static const Map<String, String> storageConditionOptions = {
    "cool_dry": "A cool, dry place",
    "hot_dry": "A really hot, but dry place", 
    "cold_dry": "A really cold, but dry place", 
    "cool_wet": "A cool, but humid / wet place", 
    "hot_wet": "A really hot, really humid / wet place", 
    "cold_wet": "A really cold, but humid / wet place (excluding ice)"
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
        child: Column(
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
              Text("Please input the conditions of storage! ", style: TextStyle(fontSize: 20),), 
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
