import 'package:flutter/foundation.dart';

class UserFeedback {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime timestamp;

  UserFeedback({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.timestamp,
  });
}
