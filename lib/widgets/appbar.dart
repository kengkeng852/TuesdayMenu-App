import 'package:flutter/material.dart';
import 'package:flutterproject/pages/screen/search.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:flutterproject/map_service/map_service.dart';


  class CustomAppBar extends StatelessWidget {
    final TextEditingController _textController = TextEditingController();
    final mapService _mapService = mapService();

    @override
    Widget build(BuildContext context) {
      return AppBar(
        backgroundColor: Color(0xFF707C4F),
        elevation: 0.0,
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(10),
          child: IconButton(
            icon: Icon(Icons.map),
            iconSize: 30,
            onPressed: () {
              _mapService.getCurrentLocation();
            },
          ),
        ),
        title: Column(
          children: [
            const Text(
              'Name of restaurant',
              style: TextStyle(
                color: Colors.black,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 5),
                padding: const EdgeInsets.symmetric(vertical: 0),
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  style: TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xffFDFED2), 
                    hintText: 'Search..',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search, color: Colors.grey),
                      onPressed: () {
                        final query = _textController.text.trim();
                        if (query.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchPage(query: query),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  controller: _textController,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
  



 