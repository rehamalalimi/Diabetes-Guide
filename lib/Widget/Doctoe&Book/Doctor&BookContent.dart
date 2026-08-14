import 'package:flutter/material.dart';

import '../../Conist.dart';
import '../../models/doctor_model.dart';
import 'D&B_DeatailScreen.dart';

class CardContent extends StatelessWidget {
  final DoctorModel doctor;

  const CardContent({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: def_Padding,
        vertical: def_Padding / 2,
      ),
      height: 190.0,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 166.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 15),
                  blurRadius: 25,
                  color: Colors.black26,
                ),
              ],
            ),
          ),
          Positioned(
            top: 15.0,
            left: 0.0,
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.symmetric(horizontal: def_Padding),
              height: 160,
              width: 200,
              child: doctor.dImageUrl.startsWith('http')
                  ? Image.network(doctor.dImageUrl, fit: BoxFit.cover)
                  : Image.asset(doctor.dImageUrl, fit: BoxFit.cover),
            ),
          ),
          Positioned(
            bottom: 0.0,
            right: 0.0,
            child: SizedBox(
              height: 136.0,
              width: size.width - 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: def_Padding),
                    child: Text(doctor.dName),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: def_Padding),
                    child: Text(doctor.specialty),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(doctor: doctor),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(def_Padding),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: def_Padding * 1.5,
                          vertical: def_Padding / 5,
                        ),
                        decoration: BoxDecoration(
                          color: SecondryColor,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Text('Book'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}