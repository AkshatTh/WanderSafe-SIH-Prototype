import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wandersafe_app/features/home/presentation/utils/map_marker_loader.dart';
import 'package:wandersafe_app/features/home/presentation/utils/map_style.dart';

class LiveMapScreen extends StatefulWidget {
  const LiveMapScreen({super.key});

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  GoogleMapController? _mapController;
  Location location = Location();
  
  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};
  
  CustomMapIcons? _customIcons;
  LatLng? _userLocation;

  final TextEditingController _searchController = TextEditingController();
  int? _selectedChipIndex;

  static const CameraPosition _kGooglePlex = CameraPosition(target: LatLng(17.3850, 78.4867), zoom: 12);

  @override
  void initState() {
    super.initState();
    _initialize();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    _customIcons = await MapMarkerLoader.loadAllIcons();
    await _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }
    final locationData = await location.getLocation();
    if (locationData.latitude != null && locationData.longitude != null) {
      final userLatLng = LatLng(locationData.latitude!, locationData.longitude!);
      _userLocation = userLatLng;
      
      final initialMarkers = MapMarkerLoader.generateInitialMarkers(userLatLng, _customIcons!);
      final userCircle = Circle(circleId: const CircleId('user_location'), center: userLatLng, radius: 50, fillColor: Colors.blue.withOpacity(0.2), strokeColor: Colors.blue, strokeWidth: 2);

      if (mounted) {
        setState(() {
          _circles.add(userCircle);
          _markers.addAll(initialMarkers);
        });
        _animateToUserLocation();
      }
    }
  }

  // --- NEW: A dedicated function to animate the camera ---
  void _animateToUserLocation() {
    if (_userLocation != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _userLocation!, zoom: 15.0),
        ),
      );
    }
  }

  void _filterByCategory(String category, int index) {
    if (_userLocation == null) return;
    if (_selectedChipIndex == index) {
      final initialMarkers = MapMarkerLoader.generateInitialMarkers(_userLocation!, _customIcons!);
      setState(() {
        _selectedChipIndex = null;
        _markers.clear();
        _markers.addAll(initialMarkers);
      });
      return;
    }
    final categoryMarkers = MapMarkerLoader.generateCategoryMarkers(_userLocation!, category, _customIcons!);
    setState(() {
      _selectedChipIndex = index;
      _markers.clear();
      _markers.addAll(categoryMarkers);
    });
  }

  void _searchOnGoogleMaps(String query) async {
    if (query.trim().isEmpty) return;
    final lat = _userLocation?.latitude ?? '17.3850';
    final lng = _userLocation?.longitude ?? '78.4867';
    final Uri googleMapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query&location=$lat,$lng');
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
       if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open maps.'), backgroundColor: Colors.red));
    }
    if(mounted) FocusScope.of(context).unfocus();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController!.setMapStyle(mapStyle);
  }

  Widget _buildFilterChip(IconData icon, String label, int index) {
    final bool isSelected = _selectedChipIndex == index;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        avatar: Icon(icon, size: 18, color: isSelected ? Colors.white : const Color(0xFF364F6B)),
        label: Text(label),
        labelStyle: TextStyle(color: isSelected ? Colors.white : const Color(0xFF364F6B), fontWeight: FontWeight.bold),
        backgroundColor: isSelected ? const Color(0xFF364F6B) : Colors.white,
        onPressed: () => _filterByCategory(label, index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: _kGooglePlex,
            circles: _circles,
            markers: _markers,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]),
                        child: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.of(context).pop()),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onSubmitted: _searchOnGoogleMaps,
                          decoration: InputDecoration(
                            hintText: 'Search for places...',
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildFilterChip(Icons.restaurant, 'Food', 0),
                      _buildFilterChip(Icons.hotel, 'Hotels', 1),
                      _buildFilterChip(Icons.store, 'Shops', 2),
                      _buildFilterChip(Icons.local_hospital, 'Hospitals', 3),
                      _buildFilterChip(Icons.local_gas_station, 'Petrol', 4),
                      _buildFilterChip(Icons.directions_car, 'Book a Ride', 5),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // --- The bottom Positioned widget has been REMOVED ---
        ],
      ),
      // --- ADDED: A floating action button to re-center the map ---
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: FloatingActionButton(
          onPressed: _animateToUserLocation, // It calls our new function
          backgroundColor: Colors.white,
          child: const Icon(Icons.my_location, color: Color(0xFF364F6B)),
        ),
      ),
    );
  }
}

