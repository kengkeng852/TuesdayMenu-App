import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutterproject/models/restaurant_firestore.dart';
import 'package:flutterproject/data/firestore_service.dart';
import 'package:flutterproject/models/app_state.dart';
import 'package:flutterproject/pages/restaurantpage/res1.dart';

class WriteReview extends StatefulWidget {
  final Restaurant restaurant;
  const WriteReview({Key? key, required this.restaurant}) : super(key: key);

  @override
  _WriteReviewState createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
  final _formKey = GlobalKey<FormState>(); 
  final _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFAAB07E),
      appBar: AppBar(title: const Text("Write a Review"), backgroundColor: Color(0xFFAAB07E),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, 
          child: Column(
            children: [
              TextFormField(
                controller: _reviewController,
                decoration: const InputDecoration(labelText: "Your Review"),
                maxLines: 3,
               validator: (value) {
                  if (value == null || value.isEmpty) {
                     return 'Please write a review';
                  }
                  return null; 
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) { 
                    _submitReview();
                  }
                },
                child: const Text("Submit Review"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitReview() async {
    final user = Provider.of<AppState>(context, listen: false).currentUser!;
    final username = user.username; 
    final reviewText = _reviewController.text; 

    try {
      final _firestoreDatabase = Provider.of<FirestoreDatabase>(context, listen: false);
      await _firestoreDatabase.addReview(widget.restaurant.id, username, reviewText, user.uid); 
      Navigator.pushReplacement( 
      context,
      MaterialPageRoute(builder: (context) => res1(id: widget.restaurant.id)),
    ); 
    } catch (error) {
      print('Error adding review: $error');
    }
  }
}

