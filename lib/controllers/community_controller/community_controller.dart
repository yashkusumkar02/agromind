import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/community_post_model/community_post_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommunityController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  RxList<CommunityPost> posts = <CommunityPost>[].obs;
  RxBool isLoading = false.obs;
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

  @override
  void onInit() {
    fetchPosts();
    super.onInit();
  }

  // ✅ Fetch all posts
  Future<void> fetchPosts() async {
    try {
      isLoading.value = true;
      var snapshot = await _db.collection("community_posts")
          .orderBy("timestamp", descending: true) // ✅ Order by Timestamp
          .get();
      posts.assignAll(snapshot.docs.map((doc) => CommunityPost.fromMap(doc.data(), doc.id)).toList());
    } catch (e) {
      print("⚠️ Error fetching posts: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Toggle Like (Like/Unlike)
  void toggleLike(String postId) async {
    var postRef = _db.collection("community_posts").doc(postId);
    var userLikeRef = postRef.collection("likes").doc(currentUserId);

    var likeDoc = await userLikeRef.get();
    if (likeDoc.exists) {
      // 👎 Unlike if already liked
      await userLikeRef.delete();
      await postRef.update({"likes": FieldValue.increment(-1)});
    } else {
      // 👍 Like the post
      await userLikeRef.set({"likedAt": FieldValue.serverTimestamp()});
      await postRef.update({"likes": FieldValue.increment(1)});
    }
    fetchPosts();
  }
// ✅ Fetch Comments
  Stream<List<Map<String, dynamic>>> fetchComments(String postId) {
    return _db
        .collection("community_posts")
        .doc(postId)
        .collection("comments")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        var data = doc.data();
        return {
          "commentId": doc.id,  // ✅ Include comment ID for edit/delete
          "userId": data["userId"] ?? "",
          "username": data["username"] ?? "Unknown User",
          "userProfilePic": data["userProfilePic"] ?? "",
          "comment": data["comment"] ?? "No comment available",  // ✅ Default value
          "timestamp": data["timestamp"] is Timestamp
              ? (data["timestamp"] as Timestamp).toDate().toString()
              : "Unknown Time",  // ✅ Handle null timestamps
        };
      }).toList();
    });
  }

  Future<void> editComment(String postId, String commentId, String newComment) async {
    try {
      await _db.collection("community_posts").doc(postId)  // ✅ Use passed `postId`
          .collection("comments").doc(commentId).update({
        "comment": newComment,
        "timestamp": FieldValue.serverTimestamp(), // ✅ Update timestamp
      });
      print("✅ Comment edited successfully!");
    } catch (e) {
      print("⚠️ Error editing comment: $e");
    }
  }

  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await _db.collection("community_posts").doc(postId)  // ✅ Use passed `postId`
          .collection("comments").doc(commentId).delete();
      print("✅ Comment deleted successfully!");
    } catch (e) {
      print("⚠️ Error deleting comment: $e");
    }
  }





  // ✅ Add Comment
  Future<void> addComment(String postId, String commentText) async {
    if (commentText.isEmpty) return;

    try {
      var user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      var userRef = _db.collection("users").doc(user.uid);
      var userData = await userRef.get();

      if (!userData.exists) {
        print("⚠️ User data not found in Firestore!");
        return;
      }

      Map<String, dynamic>? userDetails = userData.data() as Map<String, dynamic>?;

      String firstName = userDetails?["firstName"] ?? "";
      String lastName = userDetails?["lastName"] ?? "";
      String fullName = "$firstName $lastName".trim();
      String username = fullName.isNotEmpty ? fullName : "Unknown User";

      // ✅ Add Comment to Firestore
      await _db.collection("community_posts").doc(postId).collection("comments").add({
        "userId": user.uid,
        "username": username,
        "userProfilePic": userDetails?["userProfilePic"] ?? "",
        "comment": commentText,
        "timestamp": FieldValue.serverTimestamp(),
      });

      // ✅ Update Comment Count in Firestore
      await _db.collection("community_posts").doc(postId).update({
        "commentCount": FieldValue.increment(1) // ✅ Increments comment count
      });

      print("✅ Comment added successfully & comment count updated!");

      fetchPosts(); // ✅ Refresh UI to show updated comment count

    } catch (e) {
      print("⚠️ Error adding comment: $e");
    }
  }
}
