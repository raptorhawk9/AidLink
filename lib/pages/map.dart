import 'package:flutter/material.dart';
import 'package:g2e/widgets/g2e_appbar.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.title});
  final String title;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: G2EAppbar(title: widget.title),
      body: const Center(child: Text('Map Page')),
    );
  }
}
