import 'package:flutter/material.dart';

enum ReservationStatus { accepted, rejected }

class Reservation {
  final String id;
  final String title;
  final String date;
  final String time;
  final ReservationStatus status;
  final String userName;

  Reservation({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.status,
    required this.userName,
  });
}