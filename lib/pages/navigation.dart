import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:g2e/widgets/g2e_appbar.dart';

class NavigationPage extends StatefulWidget {
  final String title;

  const NavigationPage({super.key, required this.title});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AidlinkAppbar(title: widget.title),
      body: Center(
        child: Column(

        ),
      ),
    );
  }
}