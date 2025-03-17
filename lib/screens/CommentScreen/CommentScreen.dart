import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/community_controller/community_controller.dart';
import 'package:intl/intl.dart';

class CommentScreen extends StatelessWidget {
  final String postId;
  final CommunityController controller = Get.find();

  CommentScreen({required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Comments")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: controller.fetchComments(postId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                return ListView(
                  children: snapshot.data!.map((comment) {
                    return Dismissible(
                      key: Key(comment["commentId"] ?? ""), // ✅ Ensure a valid key
                      background: Container(
                        color: Colors.blue,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 20),
                        child: Icon(Icons.edit, color: Colors.white),
                      ),
                      secondaryBackground: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        String commentId = comment["commentId"] ?? "";
                        String oldComment = comment["comment"] ?? "";

                        if (direction == DismissDirection.startToEnd) {
                          // ✅ Swipe Right → Edit Comment
                          _showEditCommentDialog(context, postId, commentId, oldComment);
                          return false; // Prevents dismiss action from auto-deleting
                        } else if (direction == DismissDirection.endToStart) {
                          // ✅ Swipe Left → Delete Comment
                          bool? shouldDelete = await _showDeleteConfirmDialog(context);
                          if (shouldDelete == true) {
                            controller.deleteComment(postId, commentId);
                          }
                          return shouldDelete;
                        }
                        return false;
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: comment["userProfilePic"] != null && comment["userProfilePic"]!.isNotEmpty
                              ? NetworkImage(comment["userProfilePic"]!)
                              : AssetImage("assets/images/profile_placeholder.png") as ImageProvider, // ✅ Show default if empty
                        ),
                        title: Text(
                          comment["username"] ?? "Unknown User",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(comment["comment"] ?? "No comment available"),
                            SizedBox(height: 4),
                            Text(
                              _formatTimestamp(comment["timestamp"]),
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),

          // ✅ Input Field to Add Comments
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(),
                    decoration: InputDecoration(
                      hintText: "Write a comment...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Implement Add Comment Here
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Show Edit Comment Dialog
  void _showEditCommentDialog(BuildContext context, String postId, String commentId, String oldComment) {
    TextEditingController commentController = TextEditingController(text: oldComment);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Comment"),
          content: TextField(
            controller: commentController,
            decoration: InputDecoration(hintText: "Enter new comment"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (commentController.text.isNotEmpty) {
                  controller.editComment(postId, commentId, commentController.text);
                  Navigator.pop(context);
                }
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }
  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return "Unknown time";

    try {
      if (timestamp is String) {
        // ✅ Handle string timestamp
        return timestamp;
      } else if (timestamp is Timestamp) {
        // ✅ Convert Firestore Timestamp to readable format
        return DateFormat("dd MMM yyyy, hh:mm a").format(timestamp.toDate());
      }
    } catch (e) {
      print("⚠️ Error formatting timestamp: $e");
    }
    return "Invalid time";
  }


// ✅ Show Delete Confirmation Dialog
  Future<bool?> _showDeleteConfirmDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Comment"),
          content: Text("Are you sure you want to delete this comment?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
