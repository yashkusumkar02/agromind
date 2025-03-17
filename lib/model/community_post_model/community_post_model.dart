import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityPost {
  final String id;
  final String userId;
  final String username;
  final String userProfilePic;
  final String imageBase64;
  final String title;
  final String caption;
  final int likes;
  final int commentCount; // ✅ Ensure default value
  final DateTime timestamp;

  CommunityPost({
    required this.id,
    required this.userId,
    required this.username,
    required this.userProfilePic,
    required this.imageBase64,
    required this.title,
    required this.caption,
    required this.likes,
    required this.commentCount,
    required this.timestamp,
  });

  factory CommunityPost.fromMap(Map<String, dynamic> data, String documentId) {
    return CommunityPost(
      id: documentId,
      userId: data["userId"] ?? "",
      username: data["username"] ?? "Unknown",
      userProfilePic: data["userProfilePic"] ?? "",
      imageBase64: data["imageBase64"] ?? "",
      title: data["title"] ?? "",
      caption: data["description"] ?? "",
      likes: (data["likes"] ?? 0) as int, // ✅ Ensure integer
      commentCount: (data["commentCount"] ?? 0) as int, // ✅ Ensure integer default value
      timestamp: (data["timestamp"] is Timestamp)
          ? (data["timestamp"] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "username": username,
      "userProfilePic": userProfilePic,
      "imageBase64": imageBase64,
      "title": title,
      "caption": caption,
      "likes": likes,
      "commentCount": commentCount, // ✅ Include comment count
      "timestamp": timestamp,
    };
  }
}
