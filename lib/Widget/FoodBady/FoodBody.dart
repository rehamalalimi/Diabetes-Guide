import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../Conist.dart';
import 'FoodContent.dart';

class FoodScreenBody extends StatelessWidget {
   FoodScreenBody({super.key});

  final List<String> sliderImages = [
    'assets/images/f1.jpg',
    'assets/images/f2.jpg',
    'assets/images/f3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          // Background container
          Column(
            children: [
              SizedBox(height: def_Padding / 2),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 100),
                  decoration: BoxDecoration(
                    color: BackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                ),
              ),
            ],
          ),


          Positioned(
            top: 10,
            left: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 160, // Adjust height to match design
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                  ),
                  items: sliderImages.map((imagePath) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage(imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),


          Positioned(
            top: 180,
            left: 0,
            right: 0,
            bottom: 0,
            child: FoodContent(),
          ),
        ],
      ),
    );
  }
}
