import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigationPage extends StatefulWidget {
  final String title;

  const NavigationPage({super.key, required this.title});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final TextEditingController _destinationController = TextEditingController();

  Future<void> _launchMapsUrl(String destination) async {
    // You should get the user's current location to provide a starting point.
    // For this example, we'll hardcode the starting point to San Francisco.
    final originLatitude = 37.7749;
    final originLongitude = -122.4194;

    final uri = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&origin=$originLatitude,$originLongitude&destination=${Uri.encodeComponent(destination)}&travelmode=driving",
    );

    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _destinationController,
                decoration: const InputDecoration(
                  labelText: 'Enter Destination Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _launchMapsUrl(_destinationController.text);
                },
                child: const Text('Get Directions'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
