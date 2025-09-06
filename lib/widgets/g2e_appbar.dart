import 'package:flutter/material.dart';

class G2EAppbar extends StatelessWidget implements PreferredSizeWidget {
  
  final String title;

  const G2EAppbar({super.key, required this.title}); 

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        actions: [
          TextButton(onPressed: () => {Navigator.pushNamed(context, '/map')}, child: Text("Map")), 
          TextButton(onPressed: () => {Navigator.pushNamed(context, '/food-calc')}, child: Text("Food Calc")), 
          TextButton(onPressed: () => {print("Env Nav")}, child: Text("Environment Nav Guide")), 
        ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}