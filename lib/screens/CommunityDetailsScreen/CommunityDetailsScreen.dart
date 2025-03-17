import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CommunityDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? post = Get.arguments;

    if (post == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Community Details")),
        body: Center(child: Text("⚠️ Error: No post data available!")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(post["title"] ?? "Community Post")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Image.network(post["imageBase64"] ?? "https://via.placeholder.com/150"),
            SizedBox(height: 10),
            Text(post["description"] ?? "No description available"),
          ],
        ),
      ),
    );
  }
}
