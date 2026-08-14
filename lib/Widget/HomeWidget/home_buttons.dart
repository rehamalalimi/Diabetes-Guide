import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../screens/BloodSugarReading/initial_question_screen.dart';
import '../../screens/CheckUp/health_examination_screen.dart';
import '../../screens/Dangerous/risk.dart';
import '../../screens/DiabetesTrackingSystem/diabetes_tracker.dart';
import '../../screens/DoctorAndBook/Doctor&BookScreesn.dart';
import '../../screens/Food/FoodScreen.dart';
import '../../screens/Guid/Guid.dart';
import '../../screens/Medicine/Med.dart';
import '../../screens/Sports/Sport_Page.dart';
import '../../screens/prediction/PredictionPage.dart';


final List<Map<String, dynamic>> buttons = [
  {
    'label': 'الدليل التوعي',
    'icon': FontAwesomeIcons.lightbulb, // More appropriate for awareness
    'color': Colors.blue.shade700, // Darker blue for better visibility
    'onTap': () {
       Get.to(()=>Guid());
    }
  },
  {
    'label': 'قراءة السكر',
    'icon': FontAwesomeIcons.heartPulse, // Better for blood sugar readings
    'color': Colors.red.shade600, // Red for medical/health indicators
    'onTap': () {
      Get.to(()=>InitialQuestionScreen());
    }
  },
  {
    'label': 'الفحوصات الدورية',
    'icon': FontAwesomeIcons.userDoctor, // Represents medical checkups
    'color': Colors.teal.shade600, // Professional medical color
    'onTap': () {
      Get.to(()=>HealthExaminationScreen());
    }
  },
  {
    'label': 'مكتبة الأدوية',
    'icon': FontAwesomeIcons.pills, // Perfect for medications
    'color': Colors.purple.shade600, // Common color for medicine
    'onTap': () {
      Get.to(()=>Med());
    }
  },
  {
    'label': 'الرياضة',
    'icon': FontAwesomeIcons.dumbbell, // Better for fitness
    'color': Colors.green.shade600, // Energy/activity color
    'onTap': () {
      Get.to(()=>DiabetesFitnessScreen());
    }
  },
  {
    'label': 'التغذية',
    'icon': FontAwesomeIcons.utensils, // Better for nutrition
    'color': Colors.orange.shade600, // Appetizing food color
    'onTap': () {
      Get.to(()=>FoodScreen());
    }
  },
  {
    'label': 'الأطباء و الحجز',
    'icon': FontAwesomeIcons.userNurse, // More specific than just person
    'color': Colors.indigo.shade600, // Professional color
    'onTap': () {
      Get.to(()=>DoctorScreen());
    }
  },
  {
    'label': 'تتبع السكر',
    'icon': FontAwesomeIcons.chartLine, // Represents tracking
    'color': Colors.blue.shade600, // Trustworthy color for data
    'onTap': () {
      Get.to(()=>DailyDiabetesForm());
    },
  },
  {
    'label': 'خطر الأصابة',
    'icon': FontAwesomeIcons.triangleExclamation, // Warning icon for risk
    'color': Colors.red.shade700, // Alert color
    'onTap': () {
      Get.to(()=>PrediabetesTestScreen());
    }
  },

  {
    'label': 'التنبؤ بالسكري',
    'icon': FontAwesomeIcons.hospitalUser,  // Medical-themed icon
    'color': Colors.lightBlueAccent,  // Your secondary color (red shade) for urgency
    'onTap': () {
      Get.to(() => PredictionPage());
    }
},
];
