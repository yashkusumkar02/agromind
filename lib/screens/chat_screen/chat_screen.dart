import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/chat_controller/chat_controller.dart';
import '../custom_drawer/custom_drawer.dart'; // ✅ Import Drawer

class ChatScreen extends StatelessWidget {
  final ChatController controller = Get.put(ChatController());
  final RxBool isDrawerOpen = false.obs; // ✅ Drawer State

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // ✅ Custom Header (Replaces AppBar)
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // ✅ Open Drawer Button (Toggles Drawer)
                            GestureDetector(
                              onTap: () => isDrawerOpen.value = true,
                              child: Image.asset('assets/images/app_logo.png', height: 40),
                            ),
                            Text("AI Chat-Bot",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            // ✅ Info Button
                            IconButton(
                              icon: Icon(Icons.info_outline, color: Colors.blue, size: 30),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),

                // ✅ Chat Messages List
                Expanded(
                  child: Obx(() => ListView.builder(
                    reverse: true,
                    padding: EdgeInsets.all(10),
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      var message = controller.messages[index];
                      bool isUser = message["sender"] == "user";
                      return Align(
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                          padding: EdgeInsets.all(12),
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.75),
                          decoration: BoxDecoration(
                            color: isUser ? Colors.green[300] : Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
                          ),
                          child: Text(
                            message["text"]!,
                            style: TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ),
                      );
                    },
                  )),
                ),

                // ✅ Typing Indicator
                Obx(() => controller.isTyping.value
                    ? Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("AI is typing...", style: TextStyle(color: Colors.grey)),
                )
                    : SizedBox()),

                Divider(height: 1, color: Colors.grey[300]),

                // ✅ Input Field
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
                          ),
                          child: TextField(
                            controller: controller.textController,
                            decoration: InputDecoration(
                              hintText: "Ask about your plant...",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: controller.sendMessage,
                        child: CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Icon(Icons.send, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ✅ Custom Drawer Overlay (Closes Drawer When Tapping Outside)
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
