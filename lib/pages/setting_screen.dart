import 'package:eco/Resources/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text(
          "Settings",
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Get.height * 0.01),
              Center(
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                    ),
                    Positioned(
                      bottom: 5,
                      right: 2,
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            width: 2,
                            color: Colors.red,
                          ),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.black,
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.yellow),
                  Icon(Icons.star, color: Colors.yellow),
                  Icon(Icons.star, color: Colors.yellow),
                  Icon(Icons.star, color: Colors.yellow),
                  Icon(Icons.star, color: Colors.yellow),
                ],
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "234-7382-7398",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomListTile(
                  icon: Icons.account_circle_sharp, text: "Profile Settings"),
              Divider(),
              CustomListTile(icon: Icons.lock, text: "Password"),
              Divider(),
              CustomListTile(
                  icon: Icons.car_repair_sharp, text: "Vehicle Details"),
              Divider(),
              CustomListTile(
                  icon: Icons.calendar_month_outlined, text: "Date & Distance"),
              Divider(),
              CustomListTile(
                  icon: Icons.people_rounded, text: "Refer Friends "),
              Divider(),
              CustomListTile(
                  icon: Icons.rule_folder_sharp, text: "Rules & Terms"),
              Divider(),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Delete Account",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  const CustomListTile({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.primaryColor,
      ),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios_sharp),
      minTileHeight: 45,
    );
  }
}
