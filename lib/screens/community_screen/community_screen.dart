import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../controllers/community_controller/community_controller.dart';
import '../CommentScreen/CommentScreen.dart';
import '../custom_drawer/custom_drawer.dart';

class CommunityScreen extends StatelessWidget {
  final CommunityController controller = Get.put(CommunityController());
  final RxBool isDrawerOpen = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // ✅ Custom Header
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green[200],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => isDrawerOpen.value = true,
                          child: Image.asset('assets/images/app_logo.png', height: 40),
                        ),
                        Text("Community",
                            style: GoogleFonts.poppins(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        IconButton(
                            icon: Icon(Icons.add, color: Colors.blue, size: 30),
                            onPressed: () => Get.toNamed("/createPost")),
                      ],
                    ),
                  ),
                ),

                // ✅ Refreshable Post List
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await controller.fetchPosts();
                    },
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (controller.posts.isEmpty) {
                        return Center(child: Text("No posts yet!"));
                      }

                      return ListView.builder(
                        itemCount: controller.posts.length,
                        itemBuilder: (context, index) {
                          var post = controller.posts[index];

                          return Card(
                            margin: EdgeInsets.only(top: 10),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ✅ User Info Row (Profile + Name + Time)
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: post.userProfilePic.isNotEmpty
                                            ? NetworkImage(post.userProfilePic)
                                            : null,
                                        radius: 22,
                                        child: post.userProfilePic.isEmpty
                                            ? Icon(Icons.person, size: 22)
                                            : null,
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            post.username,
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            DateFormat("dd MMM yyyy, hh:mm a").format(post.timestamp),
                                            style: TextStyle(color: Colors.grey, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // ✅ Post Image
                                post.imageBase64.isNotEmpty
                                    ? Image.memory(
                                  base64Decode(post.imageBase64),
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                                    : SizedBox(),

                                // ✅ Title & Caption
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        post.title,
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        post.caption,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),

                                // ✅ Like & Comment Buttons
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () => controller.toggleLike(post.id),
                                            icon: Icon(
                                              Icons.favorite,
                                              color: post.likes > 0 ? Colors.red : Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            "${post.likes} Likes",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () => Get.to(() => CommentScreen(postId: post.id)),
                                            icon: Icon(Icons.comment, color: Colors.grey),
                                          ),
                                          Text(
                                            "${post.commentCount ?? 0} Comments", // ✅ Fetch and display updated count
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),

          // ✅ Custom Drawer Overlay
          Obx(() => isDrawerOpen.value
              ? GestureDetector(
            onTap: () => isDrawerOpen.value = false,
            child: Container(color: Colors.black.withOpacity(0.5)),
          )
              : SizedBox.shrink()),

          // ✅ Slide-in Custom Drawer
          Obx(() {
            return AnimatedPositioned(
              duration: Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              left: isDrawerOpen.value ? 0 : -270,
              child: CustomDrawer(onClose: () => isDrawerOpen.value = false),
            );
          }),
        ],
      ),
    );
  }
}
