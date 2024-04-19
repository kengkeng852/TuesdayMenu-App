import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; 
import 'package:location/location.dart';
import 'package:flutterproject/map_service/map_service.dart'; 
import 'package:geolocator/geolocator.dart';
import 'package:flutterproject/models/restaurant_firestore.dart'; 


class MapPage extends StatefulWidget {
  final LatLng restaurantLocation;
  final String restaurantName;
  final LatLng userLocation;

  MapPage({
    Key? key, 
    required this.restaurantLocation,
    required this.restaurantName,
    required this.userLocation,
  }) : super(key: key);
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController; 
  final mapService _mapService = mapService();
  Marker? _userLocationMarker;
  Set<Marker> _restaurantMarkers = {}; 

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _fetchRestaurantMarkers();
  }

  void _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      _updateUserMarker(position); 
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _fetchRestaurantMarkers() async {
    List<Restaurant> restaurants = await _mapService.fetchRestaurantLocations();
    setState(() {
      _restaurantMarkers = restaurants.map((restaurant) {
        final locationParts = restaurant.location!.split(', '); 
        final latlng = LatLng(
          double.parse(locationParts[0]),
          double.parse(locationParts[1]),
        );
        return Marker(
          markerId: MarkerId(restaurant.id), 
          position: latlng,
          infoWindow: InfoWindow(title: restaurant.name), 
        );
      }).toSet(); 
    });
  }

  void _updateUserMarker(Position position) {
    setState(() {
      _userLocationMarker = Marker(
        markerId: const MarkerId('user-location'),
        position: LatLng(position.latitude, position.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), 
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition( 
          target: _userLocationMarker?.position ?? LatLng(13.794416822460322, 100.3247224173162), 
          zoom: 12.0, 
         ),
       markers: {
           if (_userLocationMarker != null) _userLocationMarker!,
           Marker( 
             markerId: MarkerId(widget.restaurantName), 
             position: widget.restaurantLocation,
             infoWindow: InfoWindow(title: widget.restaurantName),
           ),
         },  
      ),
    );
  }
}
