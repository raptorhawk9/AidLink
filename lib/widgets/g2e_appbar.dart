import 'package:flutter/material.dart';

class AidlinkAppbar extends StatelessWidget implements PreferredSizeWidget {
  
  final String title;

  const AidlinkAppbar({super.key, required this.title}); 

  void navigateToNewSubpage(BuildContext context, String route) {
    Navigator.popUntil(context, ModalRoute.withName("/"));
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        actions: [
          TextButton(onPressed: () => {navigateToNewSubpage(context, '/map')}, child: Text("Disaster Map")), 
          TextButton(onPressed: () => {navigateToNewSubpage(context, '/food-calc')}, child: Text("Food Calc")), 
          TextButton(onPressed: () => {navigateToNewSubpage(context, '/nav')}, child: Text("Navigation")), 
        ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}