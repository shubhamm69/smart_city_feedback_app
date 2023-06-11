// onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:smart_city_feedback_app/models/user.dart';
import 'package:smart_city_feedback_app/models/feedback.dart';
import 'package:smart_city_feedback_app/services/api_service.dart';
import 'package:smart_city_feedback_app/widgets/main_app_bar.dart';
import 'package:smart_city_feedback_app/screens/feedback_details_screen.dart';
import 'package:smart_city_feedback_app/screens/profile_screen.dart';
import 'package:smart_city_feedback_app/screens/home_screen.dart';
import 'package:smart_city_feedback_app/screens/feedback_screen.dart';


class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List<UserFeedback> feedbackList = [];

  @override
  void initState() {
    super.initState();
    fetchFeedbackList();
  }

  Future<void> fetchFeedbackList() async {
    try {
      List<UserFeedback> feedbacks = await APIService.fetchFeedbackList();
      setState(() {
        feedbackList = feedbacks;
      });
    } catch (error) {
      // Handle error or display an error message
      print('Error fetching feedback list: $error');
    }
  }

  void addFeedback(UserFeedback feedback) {
    setState(() {
      feedbackList.add(feedback);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
      
            child: MainAppBar(
              title: 'Smart City Feedback System',
              userProfileImage: AssetImage('assets/images/sample_image.jpg'),
              onTapUserProfile: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16.0),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(16.0),
                        itemCount: feedbackList.length,
                        itemBuilder: (context, index) {
                          UserFeedback feedback = feedbackList[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FeedbackDetailsScreen(feedback: feedback),
                                ),
                              );
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      feedback.title,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      feedback.description,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final feedback = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FeedbackScreen(),
            ),
          );
          if (feedback != null) {
            addFeedback(feedback);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Feedback submitted successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

