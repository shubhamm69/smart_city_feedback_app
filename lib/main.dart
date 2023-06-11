import 'package:flutter/material.dart';
import 'package:smart_city_feedback_app/screens/home_screen.dart';
import 'package:smart_city_feedback_app/screens/onboarding_screen.dart';
import 'package:smart_city_feedback_app/screens/profile_screen.dart';
import 'package:smart_city_feedback_app/screens/feedback_screen.dart';
void main() {
  runApp(SmartCityFeedbackApp());
}

class SmartCityFeedbackApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart City Feedback App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => OnboardingScreen(),
        '/home': (context) => HomeScreen(),
        '/profile': (context) => ProfileScreen(),
        '/feedback': (context) => FeedbackScreen(),
      },
    );
  }
}
