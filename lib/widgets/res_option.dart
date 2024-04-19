import 'package:flutter/material.dart';
import 'package:flutterproject/pages/global.dart';
import 'package:flutterproject/pages/options/cheap.dart';
import 'package:flutterproject/pages/options/worldwide.dart';
import 'package:flutterproject/pages/options/highest.dart';
import 'package:flutterproject/pages/options/nearest.dart';

class OptionsBar extends StatefulWidget {
  final ValueNotifier<int> selectedIndex;
  final void Function(int newIndex) onIndexChanged;

  const OptionsBar({
    Key? key, 
    required this.selectedIndex, 
    required this.onIndexChanged
  }) : super(key: key);

  @override
  State<OptionsBar> createState() => _OptionsBarState();
}

class _OptionsBarState extends State<OptionsBar> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: widget.selectedIndex,
      builder: (context, value, child) {
        return Container(
          height: 230,
          color: const  Color(0xFFAAB07E),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => nearest()), 
                          );
                          widget.selectedIndex.value = 0;
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10, top: 15),
                          width: 180,
                          height: 80,
                          decoration: BoxDecoration(
                            color: selectedOptionIndex == 0 ? Colors.blue : const Color(0xffD4CBBC), 
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row( 
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child:
                                  Text(
                                    'The Nearest Restaurants',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Image.asset('assets/images/near.png', width: 70, height: 70),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const cheap()),
                          );
                          widget.selectedIndex.value = 1;
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 20, top: 15),
                          width: 180,
                          height: 80,
                          decoration: BoxDecoration(
                            color: selectedOptionIndex == 1 ? Colors.blue : const  Color(0xffD4CBBC), 
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row( 
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child:
                                  Text(
                                    'The Cheapest Restaurants',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Image.asset('assets/images/cheap.png', width: 70, height: 70),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const worldwide()),
                          );
                          widget.selectedIndex.value = 2;
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10, top: 15),
                          width: 180,
                          height: 80,
                          decoration: BoxDecoration(
                            color: selectedOptionIndex == 2 ? Colors.blue : const  Color(0xffD4CBBC), 
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row( 
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child:
                                  Text(
                                    'Worldwide Restaurants',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Image.asset('assets/images/favourite.png', width: 70, height: 70),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const highest()),
                          );
                          widget.selectedIndex.value = 3;
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 20, top: 15),
                          width: 180,
                          height: 80,
                          decoration: BoxDecoration(
                            color: selectedOptionIndex == 3 ? Colors.blue : const Color(0xffD4CBBC), 
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row( 
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child:
                                  Text(
                                    'The Highest Review Restaurants',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Image.asset('assets/images/highest.png', width: 70, height: 70),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
    }
  );
}
}
