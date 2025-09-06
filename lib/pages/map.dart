import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

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

// A simple model to represent a disaster event from the EONET API
class EonetEvent {
  final String id;
  final String title;
  final LatLng coordinates;
  final String categoryId;

  EonetEvent({
    required this.id,
    required this.title,
    required this.coordinates,
    required this.categoryId,
  });
}

// A model for the event categories
class EventCategory {
  final String id;
  final String title;

  EventCategory({required this.id, required this.title});
}

class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.title});
  final String title;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<EonetEvent> _events = [];
  List<EventCategory> _categories = [];
  bool _isLoading = true;
  String? _error;
  String? _selectedCategory; // This holds the ID of the selected category

  // Map to store a color for each category ID.
  final Map<String, Color> _categoryColors = {};

  @override
  void initState() {
    super.initState();
    // Fetch categories and then events when the app starts.
    _fetchEonetCategories().then((_) {
      _fetchEonetEvents();
    });
  }

  // Assigns a consistent color to each category ID.
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

  // Asynchronous function to fetch categories from the EONET API.
  Future<void> _fetchEonetCategories() async {
    try {
      final response = await http.get(
        Uri.parse('https://eonet.gsfc.nasa.gov/api/v2.1/categories'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final categories = <EventCategory>[];
        categories.add(EventCategory(id: 'all', title: 'All Events'));
        for (var category in data['categories']) {
          categories.add(
            EventCategory(
              id: category['id'].toString(),
              title: category['title'],
            ),
          );
        }
        setState(() {
          _categories = categories;
          _selectedCategory = 'all'; // Set initial filter to show all events.
          _assignCategoryColors();
        });
      } else {
        setState(() {
          _error =
              'Failed to load categories. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'An error occurred while fetching categories: $e';
      });
    }
  }

  // Asynchronous function to fetch events from the EONET API.
  Future<void> _fetchEonetEvents() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://eonet.gsfc.nasa.gov/api/v2.1/events'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final events = <EonetEvent>[];
        for (var event in data['events']) {
          if (event['geometries'] != null && event['geometries'].isNotEmpty) {
            for (var geometry in event['geometries']) {
              if (geometry['type'] == 'Point') {
                final coords = geometry['coordinates'];
                // Get the first category for the event to use for filtering and coloring.
                final categoryId =
                    event['categories'] != null &&
                        event['categories'].isNotEmpty
                    ? event['categories'][0]['id'].toString()
                    : 'unknown';
                events.add(
                  EonetEvent(
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
        setState(() {
          _events = events;
        });
      } else {
        setState(() {
          _error = 'Failed to load events. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'An error occurred while fetching events: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter the events list based on the selected category
    final filteredEvents = _selectedCategory == 'all'
        ? _events
        : _events
              .where((event) => event.categoryId == _selectedCategory)
              .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          // Dropdown for category filtering
          if (_categories.isNotEmpty)
            DropdownButton<String>(
              value: _selectedCategory,
              icon: const Icon(Icons.arrow_downward, color: Colors.white),
              dropdownColor: Colors.grey[800],
              style: const TextStyle(color: Colors.white),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              items: _categories.map<DropdownMenuItem<String>>((
                EventCategory category,
              ) {
                return DropdownMenuItem<String>(
                  value: category.id,
                  child: Text(category.title),
                );
              }).toList(),
            ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _isLoading ? null : _fetchEonetEvents,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text('Error: $_error'))
          : FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(0, 0),
                initialZoom: 2.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
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
                          // Use the color associated with the event's category
                          color:
                              _categoryColors[event.categoryId] ?? Colors.red,
                          size: 40.0,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
    );
  }
}
