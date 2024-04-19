import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  final String id;
  final String name;
  final String location;
  final String mainPhoto;
  final String rating;
  final String reviewCount;
  final String time;
  final String price;
  final String address;
  bool isLike;
  final String description;
  List<Review> review;
  

  Restaurant({
    required this.id,
    required this.name,
    required this.location,
    required this.mainPhoto,
    required this.rating,
    required this.reviewCount,
    required this.time,
    required this.price,
    required this.address,
    required this.isLike,
    required this.description, 
    this.review = const [],
  });

  factory Restaurant.fromFirestore(DocumentSnapshot doc) {
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  return Restaurant(
    id: doc.id,
    name: data['name'] ?? '',
    location: data['location'] ?? '',
    mainPhoto: data['mainPhoto'] ?? '',
    rating: data['rating'] ?? '',
    reviewCount: data['reviewCount'] ?? 0,
    time: data['time'] ?? '',
    price: data['price'] ?? '',
    address: data['address'] ?? '',
    isLike: data['isLike'] ?? false,
    description: data['description'] ?? '',
    review: (data['review'] as List<dynamic>?)
      ?.map((item) => Review.fromMap(item as Map<String, dynamic>))
      .toList() ?? [],
  );
}
}

class Review { 
  List<String>? name;
  String? review;
  String? id; 

  Review({this.name, this.review, this.id});

  factory Review.fromMap(Map<String, dynamic> reviewData) {  
  return Review(
    name: (reviewData['0']?.toString()?.split(',') as List<String>?) 
            ?.where((name) => name.isNotEmpty).toList() ?? ['Anonymous'], 
    review: reviewData['1'],
    id: reviewData['2'],
  );
}

  Map<String, dynamic> toMap() { 
    return {
      '0': name!.join(','), 
      '1': review,
      '2': id,
    };
  }
}
