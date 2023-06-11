import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_city_feedback_app/models/feedback.dart';

class FeedbackDetailsScreen extends StatefulWidget {
  final UserFeedback feedback;

  const FeedbackDetailsScreen({required this.feedback});

  @override
  _FeedbackDetailsScreenState createState() => _FeedbackDetailsScreenState();
}

class _FeedbackDetailsScreenState extends State<FeedbackDetailsScreen> {
  int _upvotes = 0;
  int _downvotes = 0;
  bool _isUpvoted = false;
  bool _isDownvoted = false;
  List<String> _comments = [];
  TextEditingController _commentController = TextEditingController();

  void _upvote() {
    if (!_isUpvoted) {
      setState(() {
        _upvotes++;
        _isUpvoted = true;
        if (_isDownvoted) {
          _downvotes--;
          _isDownvoted = false;
        }
      });
    }
  }

  void _downvote() {
    if (!_isDownvoted) {
      setState(() {
        _downvotes++;
        _isDownvoted = true;
        if (_isUpvoted) {
          _upvotes--;
          _isUpvoted = false;
        }
      });
    }
  }

  void _addComment(String comment) {
    setState(() {
      _comments.add(comment);
      _commentController.clear(); // Clear the text field after adding the comment
    });
  }

  @override
  void dispose() {
    _commentController.dispose(); // Dispose the TextEditingController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formattedTimestamp =
        DateFormat.yMd().add_jm().format(widget.feedback.timestamp.toLocal());

    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.feedback.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                widget.feedback.description,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 16.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  widget.feedback.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                '$formattedTimestamp',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 24.0),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.thumb_up),
                    color: _isUpvoted ? Colors.blue : Colors.grey,
                    onPressed: _upvote,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    'Upvotes: $_upvotes',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  IconButton(
                    icon: Icon(Icons.thumb_down),
                    color: _isDownvoted ? Colors.blue : Colors.grey,
                    onPressed: _downvote,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    'Downvotes: $_downvotes',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.0),
              Text(
                'Comments',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          '${index + 1}. ${_comments[index]}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
              SizedBox(height: 24.0),
              Container(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Add a comment',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        final comment = _commentController.text;
                        _addComment(comment);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
