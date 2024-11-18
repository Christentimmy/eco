import 'package:eco/Resources/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatMenuScreen extends StatelessWidget {
  const ChatMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        title: const Text(
          "Clara Smith",
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Icon(Icons.call, color: AppColors.primaryColor,),
          const SizedBox(width: 10),
          // Icon(Icons.more_vert_sharp),
          // SizedBox(width: 15),
        ],
      ),
    );
  }
}
