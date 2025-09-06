import 'package:flutter/material.dart';

class G2EAppbar extends StatelessWidget implements PreferredSizeWidget {
  
  final String title;

  const G2EAppbar({super.key, required this.title}); 

  void navigateToNewSubpage(BuildContext context, String route) {
    print("hi");
    Navigator.popUntil(context, ModalRoute.withName("/"));
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        actions: [
          TextButton(onPressed: () => {navigateToNewSubpage(context, '/map')}, child: Text("Map")), 
          TextButton(onPressed: () => {navigateToNewSubpage(context, '/food-calc')}, child: Text("Food Calc")), 
          TextButton(onPressed: () => {print("Env Nav")}, child: Text("Environment Nav Guide")), 
        ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}