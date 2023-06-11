import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_city_feedback_app/models/user.dart';
import 'package:smart_city_feedback_app/models/feedback.dart';

class APIService {
  static const String baseUrl = 'https://5b69-122-187-117-178.ngrok-free.app';

  static Future<User> fetchUserProfile() async {
    final response = await http.get(Uri.parse('$baseUrl/user-profile'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User(
        id: data['id'],
        name: data['name'],
        email: data['email'],
        phoneNumber: data['phoneNumber'],
        address: data['address'],
        dateOfBirth: data['dateOfBirth'],
        upvotes: data['upvotes'],
        downvotes: data['downvotes'],
      );
    } else {
      throw Exception('Failed to fetch user profile');
    }
  }

  static Future<List<UserFeedback>> fetchFeedbackList() async {
    final response = await http.get(Uri.parse('$baseUrl/feedback-list'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      List<UserFeedback> feedbackList = data.map((item) {
        return UserFeedback(
          id: item['id'],
          title: item['title'],
          description: item['description'],
          imageUrl: item['imageUrl'],
          timestamp: DateTime.parse(item['timestamp']),
        );
      }).toList();
      return feedbackList;
    } else {
      throw Exception('Failed to fetch feedback list');
    }
  }

  static Future<void> submitFeedback(UserFeedback feedback) async {
    final response = await http.post(
      Uri.parse('$baseUrl/submit-feedback'),
      body: json.encode({
        'title': feedback.title,
        'description': feedback.description,
        'imageUrl': feedback.imageUrl,
        // Include other necessary properties in the request body
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to submit feedback');
    }
  }
}
