import 'package:flutter/material.dart';
import 'package:flutterproject/pages/home.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; 
import 'package:provider/provider.dart';
import 'package:flutterproject/models/restaurant_firestore.dart'; 
import 'package:flutterproject/data/firestore_service.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterproject/models/app_state.dart';
import 'package:flutterproject/pages/restaurantpage/review.dart';
import 'package:flutterproject/map_service/map_service.dart';
import 'package:flutterproject/pages/screen/map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutterproject/widgets/nav.dart';

class res1 extends StatefulWidget {
 static const routeName = '/detail';
 final String id;
 const res1({Key? key, required this.id}) : super(key: key); 

 @override
  _res1State createState() => _res1State();
}

class _res1State extends State<res1> {
  final FirestoreDatabase _firestoreDatabase = FirestoreDatabase();
  FetchResultState _fetchState = FetchResultState.initial;
  Restaurant? _restaurant;
  bool _isSaved = false; 
  LatLng? _restaurantLocation; 
  final mapService _mapService = mapService();
  final selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AppState>(context, listen: false).currentUser;
    if (user != null) {
     _fetchData();
   }
  }

  Future<void> _fetchData() async {
    setState(() => _fetchState = FetchResultState.loading);

    try {
      final restaurant = await _firestoreDatabase.fetchRestaurantDetail(widget.id);
      final isSaved = await _firestoreDatabase.checkSavedStatus(Provider.of<AppState>(context, listen: false).currentUser!.uid, widget.id); 

      setState(() {
        _fetchState = FetchResultState.hasData;
        _restaurant = restaurant;
        _isSaved = isSaved; 
      });
    } catch (error) {
      setState(() => _fetchState = FetchResultState.error);
    }
  }

  Future<void> _toggleSavedStatus() async {
    final uid = Provider.of<AppState>(context, listen: false).currentUser!.uid;

    try {
      await _firestoreDatabase.updateSavedRestaurants(uid, widget.id, !_isSaved);

      setState(() {
        _isSaved = !_isSaved; 
        _restaurant!.isLike = _isSaved; 
      });

    } catch (error) {
      print('Error updating saved status: $error');
    }
  }

  Widget _buildInfo(Restaurant restaurant) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (restaurant.mainPhoto.isNotEmpty) 
          Center( 
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                restaurant.mainPhoto, 
                height: 200, 
                width: double.infinity, 
                fit: BoxFit.cover, 
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child; 
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              restaurant.name, 
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Row( 
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: Colors.yellow, 
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Text(
                      restaurant.rating,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
                const SizedBox(width: 32.0),
                Row(  
                  children: [
                    Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: Colors.blue, 
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                    const SizedBox(width: 16.0),
                    Text(
                      restaurant.address, 
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              restaurant.description ?? "", 
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          SizedBox(height: 5.0),
          Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Phone:    087-441-6573",
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Map ",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
          ),
          GestureDetector(
              onTap: () => _navigateToMap(context, restaurant),
              child: Container(
                height: 200,
                width: double.infinity,
                child: Image.network(
                  _buildStaticMapUrl(restaurant.location!), 
                  fit: BoxFit.cover,
                ),
              ),
          ),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }

  Widget _buildReview(Restaurant restaurant) {
    if (restaurant.review.isEmpty) {
      return const Text("No reviews yet."); 
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Reviews",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8.0),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
            itemCount: restaurant.review.length,
          itemBuilder: (context, index) {
            final review = restaurant.review[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16.0), 
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.grey[100], 
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row( 
                    children: [
                      for (final name in review.name!)
                        Expanded(
                          child: Text( 
                            name, 
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
                          ),
                        ), 
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                      review.review!, 
                      maxLines: 3, 
                      overflow: TextOverflow.ellipsis, 
                  ),
                ],
              ),
            ); 
          },
        ),
      ],
    );
  }

  Widget _buildFavoriteButton(Restaurant restaurant) {
    return IconButton(
      iconSize: 30.0,
      icon: Icon(
        _isSaved ? Icons.favorite : Icons.favorite_border,
        color: _isSaved ? Colors.redAccent : Colors.grey,
      ),
      onPressed: _toggleSavedStatus,
    );
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffD4CBBC), 
      appBar: AppBar(
        title: const Text("Restaurant Detail"),
        backgroundColor: Color(0xffD4CBBC), 
        actions: [
          if (_fetchState == FetchResultState.hasData && _restaurant != null)
          _buildFavoriteButton(_restaurant!)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_fetchState == FetchResultState.loading)
                  const Center(child: CircularProgressIndicator())
                else if (_fetchState == FetchResultState.error)
                  const Center(child: Text("Error loading details"))
                else if (_fetchState == FetchResultState.hasData && _restaurant != null) ...[
                  _buildInfo(_restaurant!),
                  _buildReview(_restaurant!),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        child: const Text("Write Review"),
                        onPressed: () {
                          Navigator.pushReplacement( 
                            context,
                            MaterialPageRoute(builder: (context) => WriteReview(restaurant: _restaurant!)),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
     bottomNavigationBar: BottomNavBar(selectedIndex: selectedIndex),
    );
  }
}

String _buildStaticMapUrl(String restaurantLocation) {
    const apiKey = 'AIzaSyA3tgir6l0AROLs3-dF3GK3sK8TWyoIU3g'; 
    final locationParts = restaurantLocation.split(', ');
    final latitude = locationParts[0];
    final longitude = locationParts[1];

    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=15&size=600x300&markers=color:red|$latitude,$longitude&key=$apiKey';
}

void _navigateToMap(BuildContext context, Restaurant restaurant) async {
  Position userPosition = await mapService().getCurrentLocation();    
  Navigator.of(context, rootNavigator: true).push(
    MaterialPageRoute(builder: (context) => MapPage(
      restaurantLocation: _parseRestaurantLocation(restaurant.location!),
      restaurantName: restaurant.name,
      userLocation: LatLng(userPosition.latitude, userPosition.longitude),
    )),
  );
}

LatLng _parseRestaurantLocation(String locationString) {
  final locationParts = locationString.split(', ');
  return LatLng(
    double.parse(locationParts[0]),
    double.parse(locationParts[1]),
  );
}

class DetailProvider extends ChangeNotifier {
  final FirestoreDatabase _firestoreDatabase = FirestoreDatabase();
  Restaurant _restaurant = Restaurant(
    id: '',
    name: '',
    location: '',
    mainPhoto: '',
    rating: '',
    reviewCount: '',
    time: '',
    price: '',
    address: '',
    isLike: false,
    description: '',
    review: [Review()],
  );
  FetchResultState _fetchState = FetchResultState.initial;

  Restaurant get restaurant => _restaurant;
  FetchResultState get fetchState => _fetchState;

}

enum FetchResultState { initial, loading, error, hasData } 