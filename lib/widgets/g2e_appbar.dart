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
      title: Row(
        children: [
          Text("AidLink"),
          Padding(padding: EdgeInsetsGeometry.directional(start: 18)),
          Image.asset("images/dove.png", scale: 8),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => {navigateToNewSubpage(context, '/map')},
          child: Text("Disaster Map", style: TextStyle(color: Colors.black)),
        ),
        TextButton(
          onPressed: () => {navigateToNewSubpage(context, '/food-calc')},
          child: Text("Food Calc", style: TextStyle(color: Colors.black)),
        ),
        TextButton(
          onPressed: () => {navigateToNewSubpage(context, '/nav')},
          child: Text("Navigation", style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
