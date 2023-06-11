import 'package:flutter/material.dart';
import 'package:smart_city_feedback_app/models/user.dart';
import 'package:smart_city_feedback_app/models/feedback.dart';
import 'package:smart_city_feedback_app/services/api_service.dart';
import 'package:smart_city_feedback_app/widgets/app_bar.dart';
import 'package:smart_city_feedback_app/widgets/button.dart';
import 'package:smart_city_feedback_app/screens/home_screen.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _imageUrlController = TextEditingController();

  Future<void> submitFeedback() async {
    String title = _titleController.text;
    String description = _descriptionController.text;
    String imageUrl = _imageUrlController.text;

    UserFeedback feedback = UserFeedback(
      id: '',
      title: title,
      description: description,
      imageUrl: imageUrl,
      timestamp: DateTime.now(),
    );

    try {
      await APIService.submitFeedback(feedback);
      // Show success message or navigate to a success screen

      // Navigate back to OnboardingScreen and pass the feedback object
      Navigator.pop(context, feedback);
    } catch (error) {
      // Handle error or display an error message
      print('Error submitting feedback: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting feedback'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Submit Feedback'),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _imageUrlController,
              decoration: InputDecoration(
                labelText: 'Image URL',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: submitFeedback,
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                textStyle: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
