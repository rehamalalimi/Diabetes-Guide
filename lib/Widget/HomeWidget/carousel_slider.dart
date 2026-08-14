import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class carousel_slider extends StatelessWidget {
  final String imagePath;

  carousel_slider({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return
      Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.only(left: 2,right: 2,top: 0.0),
      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          imagePath,
          width: double.infinity,
          height: 200,  // Adjust the height as needed
          fit: BoxFit.cover, // Ensures the image fills the container
        ),
      ),
    );
  }
}
