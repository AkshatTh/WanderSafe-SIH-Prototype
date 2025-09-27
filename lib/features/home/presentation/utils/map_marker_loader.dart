import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMapIcons {
  final BitmapDescriptor safeIcon;
  final BitmapDescriptor unsafeIcon;
  final BitmapDescriptor tourismSpotIcon;
  final BitmapDescriptor animalWarningIcon;
  final BitmapDescriptor foodIcon;
  final BitmapDescriptor shopIcon;
  final BitmapDescriptor taxiIcon;
  final BitmapDescriptor petrolIcon;
  final BitmapDescriptor hospitalIcon;

  CustomMapIcons({
    required this.safeIcon,
    required this.unsafeIcon,
    required this.tourismSpotIcon,
    required this.animalWarningIcon,
    required this.foodIcon,
    required this.shopIcon,
    required this.petrolIcon,
    required this.taxiIcon,
    required this.hospitalIcon,
  });
}

class MapMarkerLoader {
  static Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  static Future<CustomMapIcons> loadAllIcons() async {
    const int iconSize = 120;
    final results = await Future.wait([
      _getBytesFromAsset('assets/images/safe.png', iconSize),
      _getBytesFromAsset('assets/images/unsafe.png', iconSize),
      _getBytesFromAsset('assets/images/tourism_spot.png', iconSize),
      _getBytesFromAsset('assets/images/animal_warning.png', iconSize),
      _getBytesFromAsset('assets/images/food.png', iconSize),
      _getBytesFromAsset('assets/images/shop.png', iconSize),
      _getBytesFromAsset('assets/images/hospital.png', iconSize),
      _getBytesFromAsset('assets/images/petrol.png', iconSize),
      _getBytesFromAsset('assets/images/taxi.png', iconSize),
    ]);

    return CustomMapIcons(
      safeIcon: BitmapDescriptor.fromBytes(results[0]),
      unsafeIcon: BitmapDescriptor.fromBytes(results[1]),
      tourismSpotIcon: BitmapDescriptor.fromBytes(results[2]),
      animalWarningIcon: BitmapDescriptor.fromBytes(results[3]),
      foodIcon: BitmapDescriptor.fromBytes(results[4]),
      shopIcon: BitmapDescriptor.fromBytes(results[5]),
      hospitalIcon: BitmapDescriptor.fromBytes(results[6]),
      petrolIcon: BitmapDescriptor.fromBytes(results[7]),
      taxiIcon: BitmapDescriptor.fromBytes(results[8]),
    );
  }

  static LatLng _getRandomLocation(LatLng center, double radius) {
    final Random random = Random();
    double y0 = center.latitude;
    double x0 = center.longitude;
    double rd = radius / 111300;
    double u = random.nextDouble();
    double v = random.nextDouble();
    double w = rd * sqrt(u);
    double t = 2 * pi * v;
    double x = w * cos(t);
    double y = w * sin(t);
    return LatLng(y + y0, x + x0);
  }

  static List<Marker> generateInitialMarkers(LatLng userLocation, CustomMapIcons icons) {
     return [
      Marker(markerId: const MarkerId('safe_1'), position: _getRandomLocation(userLocation, 1500), icon: icons.safeIcon, infoWindow: const InfoWindow(title: 'Safe Area')),
      Marker(markerId: const MarkerId('unsafe_1'), position: _getRandomLocation(userLocation, 1500), icon: icons.unsafeIcon, infoWindow: const InfoWindow(title: 'Use Caution')),
      Marker(markerId: const MarkerId('tourism_1'), position: _getRandomLocation(userLocation, 1500), icon: icons.tourismSpotIcon, infoWindow: const InfoWindow(title: 'Tourist Spot')),
      Marker(markerId: const MarkerId('animal_1'), position: _getRandomLocation(userLocation, 1500), icon: icons.animalWarningIcon, infoWindow: const InfoWindow(title: 'Animal Warning')),
      Marker(markerId: const MarkerId('food_1'), position: _getRandomLocation(userLocation, 1500), icon: icons.foodIcon, infoWindow: const InfoWindow(title: 'Food')),
      Marker(markerId: const MarkerId('shop_1'), position: _getRandomLocation(userLocation, 1500), icon: icons.shopIcon, infoWindow: const InfoWindow(title: 'Shop')),
      Marker(markerId: const MarkerId('hospital_1'), position: _getRandomLocation(userLocation, 1500), icon: icons.hospitalIcon, infoWindow: const InfoWindow(title: 'Hospital')),
      Marker(markerId: const MarkerId('petrol_1'), position: _getRandomLocation(userLocation, 1500), icon: icons.petrolIcon, infoWindow: const InfoWindow(title: 'Petrol Pump')),
      Marker(markerId: const MarkerId('taxi_1'), position: _getRandomLocation(userLocation, 1500), icon: icons.taxiIcon, infoWindow: const InfoWindow(title: 'Taxi Spot')),

    ];
  }

  // --- NEW FUNCTION TO GENERATE MARKERS FOR A SPECIFIC CATEGORY ---
  static List<Marker> generateCategoryMarkers(LatLng userLocation, String category, CustomMapIcons icons) {
    List<Marker> markers = [];
    int count = 4; // Generate 4 mock locations for the selected category

    // Select the icon based on the category
    BitmapDescriptor icon;
    switch (category) {
      case 'Food':
        icon = icons.foodIcon; // Re-using an icon, you can add a specific one
        break;
      case 'Shops':
        icon = icons.shopIcon; // Re-using an icon, you can add a specific one
        break;
      case 'Hotels':
        icon = icons.safeIcon; // Re-using an icon
        break;
        
      case 'Petrol':
        icon = icons.petrolIcon; // Re-using an icon
        break;

      case 'Book a Ride':
        icon = icons.taxiIcon; // Re-using an icon
        break;

      case 'Hospitals':
        icon = icons.hospitalIcon; // Re-using an icon
        break;
      
      
      default:
        icon = icons.tourismSpotIcon;
    }

    for (int i = 0; i < count; i++) {
      markers.add(
        Marker(
          markerId: MarkerId('${category}_$i'),
          position: _getRandomLocation(userLocation, 2000), // within 1km
          icon: icon,
          infoWindow: InfoWindow(title: category),
        )
      );
    }
    return markers;
  }
}