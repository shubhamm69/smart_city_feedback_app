import 'package:flutter/material.dart';
import 'package:smart_city_feedback_app/models/user.dart';
import 'package:smart_city_feedback_app/models/feedback.dart';
import 'package:smart_city_feedback_app/services/api_service.dart';
import 'package:smart_city_feedback_app/widgets/feedback_card.dart';
import 'package:smart_city_feedback_app/widgets/app_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<UserFeedback> feedbackList = [];
  List<UserFeedback> filteredList = [];
  late AnimationController _animationController;
  late Animation<double> _animation;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchFeedbackList();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchFeedbackList() async {
    try {
      List<UserFeedback> feedbacks = await APIService.fetchFeedbackList();
      setState(() {
        feedbackList = feedbacks;
        filteredList = feedbacks; // Initialize the filtered list with all feedbacks
      });
    } catch (error) {
      // Handle error or display an error message
      print('Error fetching feedback list: $error');
    }

    // Start the animation after feedback data is fetched
    _animationController.forward();
  }

  void searchFeedbacks(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredList = feedbackList; // Show all feedbacks if search query is empty
      });
    } else {
      setState(() {
        filteredList = feedbackList
            .where((feedback) =>
                feedback.title.toLowerCase().contains(query.toLowerCase()))
            .toList(); // Filter the feedbacks based on search query
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Feedback List'),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E1E1E), Color(0xFF121212)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Opacity(
              opacity: _animation.value,
              child: Transform.translate(
                offset: Offset(0, 100 * (1 - _animation.value)),
                child: child,
              ),
            );
          },
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    searchFeedbacks(value);
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Search Feedbacks',
                    labelStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    UserFeedback feedback = filteredList[index];
                    String limitedDescription = feedback.description
                        .split(' ')
                        .take(5)
                        .join(' '); // Limit the description to 5 words

                    return FeedbackCard(
                      feedback: feedback,
                      limitedDescription: limitedDescription,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: _animation,
        child: FloatingActionButton(
          onPressed: () async {
            await Navigator.pushNamed(context, '/feedback');
            fetchFeedbackList(); // Refresh the feedback list after returning from the feedback screen
          },
          child: Icon(Icons.add),
          backgroundColor: Color(0xFF0A84FF),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
