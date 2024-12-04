import 'package:eco/resources/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Notification",
          style: TextStyle(),
        ),
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back_ios,
            ),
          ),
        ),
        actions: [
          CircleAvatar(
            radius: 15,
            backgroundColor: AppColors.primaryColor,
            child: Text(
              "12",
              style: TextStyle(
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: [
            Container(
              height: 55,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color.fromARGB(255, 83, 83, 83),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 196, 196, 196),
                    blurRadius: 2,
                    spreadRadius: 1,
                  )
                ],
                border: Border.all(
                  color: const Color.fromARGB(255, 151, 151, 151),
                ),
              ),
              child: ListTile(
                title: Text(
                  "Christen Timmy",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                subtitle: Text("Your booking #1234 has been suc..."),
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.card_travel),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
