import 'package:flutter/material.dart';
import '../../Conist.dart';
import 'CheckUpContent.dart';
class CheckupScreen extends StatelessWidget {
  const CheckupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          children: [
            SizedBox(height: def_Padding /2 ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 70.0),
                    decoration: BoxDecoration(
                      color: BackgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    height: double.infinity,
                  ),
                  CheckupContent(),
                ],
              ),
            )
          ],
        ));
  }
}
