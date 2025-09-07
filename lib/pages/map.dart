import 'package:flutter/material.dart';
import 'package:g2e/widgets/g2e_appbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

// MyApp is a stateless widget that doesn't change once created
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Disaster Map',
      home: MapPage(title: 'Disaster Map'),
    );
  }
}

// DisasterEvent holds all the information we need for one event.
class DisasterEvent {
  final String id;
  final String title;
  final LatLng coordinates;
  final String categoryId;

  DisasterEvent({
    required this.id,
    required this.title,
    required this.coordinates,
    required this.categoryId,
  });
}

// This is a blueprint for the different types of events, like "Wildfire" or "Flood."
class DisasterCategory {
  final String id;
  final String title;

  DisasterCategory({required this.id, required this.title});
}

// Main map screen. It's a "stateful" widget because the map and the markers will change over time.
class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.title});
  final String title;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // Lists to store the disaster events and categories from the EONET API.
  List<DisasterEvent> _events = [];
  List<DisasterCategory> _categories = [];

  // Helps to control the map like zooming in and out
  final MapController _mapController = MapController();

  // Only show markers when the map is zoomed in past zoomThreshold to reduce lag.
  final double _zoomThreshold = 5.0;
  double _currentZoom = 2.0;
  bool _isLoading = true;

  // Stores ID of the category currently selected in the dropdown menu.
  String? _selectedCategory;

  // This map stores a color for each type of disaster, so they look different on the map.
  final Map<String, Color> _categoryColors = {};

  @override
  void initState() {
    super.initState();
    // When the page first loads, we "ask" the internet for the categories and then the events.
    _fetchEonetCategories().then((_) {
      _fetchEonetEvents();
    });

    // We listen to the map to know when the user zooms in or out.
    _mapController.mapEventStream.listen((mapEvent) {
      // If the map has moved, we update our variable that tracks the zoom level.
      if (mapEvent is MapEventMove || mapEvent is MapEventMoveEnd) {
        setState(() {
          _currentZoom = _mapController.camera.zoom;
        });
      }
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  // Function assigns a color to each type of disaster.
  void _assignCategoryColors() {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.indigo,
    ];
    for (int i = 0; i < _categories.length; i++) {
      _categoryColors[_categories[i].id] = colors[i % colors.length];
    }
  }

  // Get data from NASA API to get a list of all the disaster categories.
  Future<void> _fetchEonetCategories() async {
    final response = await http.get(
      Uri.parse('https://eonet.gsfc.nasa.gov/api/v2.1/categories'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final categories = <DisasterCategory>[];
      categories.add(DisasterCategory(id: 'all', title: 'All Events'));
      for (var category in data['categories']) {
        categories.add(
          DisasterCategory(
            id: category['id'].toString(),
            title: category['title'],
          ),
        );
      }
      // Tells the app to refresh and draw the new categories on the screen.
      setState(() {
        _categories = categories;
        _selectedCategory = 'all';
        _assignCategoryColors();
      });
    }
  }

  // Gets data from the NASA API to get a list of all the recent disaster events.
  Future<void> _fetchEonetEvents() async {
    // Shows a loading circle while waiting for the internet.
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(
      Uri.parse('https://eonet.gsfc.nasa.gov/api/v2.1/events'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final events = <DisasterEvent>[];
      for (var event in data['events']) {
        if (event['geometries'] != null && event['geometries'].isNotEmpty) {
          for (var geometry in event['geometries']) {
            if (geometry['type'] == 'Point') {
              final coords = geometry['coordinates'];
              final categoryId =
                  event['categories'] != null && event['categories'].isNotEmpty
                  ? event['categories'][0]['id'].toString()
                  : 'unknown';
              events.add(
                DisasterEvent(
                  id: event['id'],
                  title: event['title'],
                  coordinates: LatLng(coords[1], coords[0]),
                  categoryId: categoryId,
                ),
              );
            }
          }
        }
      }
      // Tells the app to refresh and show the new markers on the screen.
      setState(() {
        _events = events;
      });
    }
    // Hids the loading circle once the data is ready.
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This line filters the events based selected category.
    final filteredEvents = _selectedCategory == 'all'
        ? _events
        : _events
              .where((event) => event.categoryId == _selectedCategory)
              .toList();

    return Scaffold(
      appBar: const AidlinkAppbar(title: 'Disaster Map'),
      body: Stack(
        children: [
          // If its loading, shows a spinner. If not, shows the map.
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
                  mapController: _mapController,
                  options: const MapOptions(
                    initialCenter: LatLng(0, 0),
                    initialZoom: 2.0,
                  ),
                  children: [
                    // This is the background of the map, like a simple world map.
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    // Markers are only shown if the map is zoomed in enough.
                    if (_currentZoom >= _zoomThreshold)
                      MarkerLayer(
                        markers: filteredEvents.map((event) {
                          return Marker(
                            width: 80.0,
                            height: 80.0,
                            point: event.coordinates,
                            child: Tooltip(
                              message: event.title,
                              child: Icon(
                                Icons.location_on,
                                color:
                                    _categoryColors[event.categoryId] ??
                                    Colors.red,
                                size: 40.0,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
          // Places the dropdown and refresh buttons on top of the map
          Positioned(
            top: 16,
            right: 16,
            child: MapActionsWidget(
              categories: _categories,
              selectedCategory: _selectedCategory,
              onCategoryChanged: (newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              onRefresh: _fetchEonetEvents,
              isLoading: _isLoading,
            ),
          ),
        ],
      ),
    );
  }
}

// Separate widget for the buttons and dropdown menu.
class MapActionsWidget extends StatelessWidget {
  final List<DisasterCategory> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onCategoryChanged;
  final VoidCallback onRefresh;
  final bool isLoading;

  const MapActionsWidget({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.onRefresh,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (categories.isNotEmpty)
              DropdownButton<String>(
                value: selectedCategory,
                icon: const Icon(Icons.arrow_downward, color: Colors.white),
                dropdownColor: Colors.grey[800],
                style: const TextStyle(color: Colors.white),
                onChanged: onCategoryChanged,
                items: categories.map<DropdownMenuItem<String>>((category) {
                  return DropdownMenuItem<String>(
                    value: category.id,
                    child: Text(category.title),
                  );
                }).toList(),
              ),
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: isLoading ? null : onRefresh,
              tooltip: 'Refresh Events',
            ),
          ],
        ),
      ),
    );
  }
}
