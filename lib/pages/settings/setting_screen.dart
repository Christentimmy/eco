import 'package:eco/Resources/color_resources.dart';
import 'package:eco/pages/settings/change_password_screen.dart';
import 'package:eco/pages/settings/date_distance_screen.dart';
import 'package:eco/pages/settings/faq_screen.dart';
import 'package:eco/pages/settings/profile_screen.dart';
import 'package:eco/pages/settings/rule_terms_screen.dart';
import 'package:eco/pages/settings/vehicle_profile_screen.dart';
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
            fontSize: 17,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
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
              UserPictureWithButton(),
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
                icon: Icons.account_circle_sharp,
                text: "Profile Settings",
                onTap: (){
                  Get.to(()=> ProfileScreen());
                },
              ),
              Divider(),
              CustomListTile(
                icon: Icons.lock,
                text: "Password",
                onTap: (){
                  Get.to(()=> ChangePasswordScreen());
                },
              ),
              Divider(),
              CustomListTile(
                icon: Icons.car_repair_sharp,
                text: "Vehicle Details",
                onTap: (){
                  Get.to(()=> VehicleProfileScreen());
                },
              ),
              Divider(),
              CustomListTile(
                icon: Icons.calendar_month_outlined,
                text: "FAQ",
                onTap: (){
                  Get.to(()=> FaqScreen());
                },
              ),
              Divider(),
              CustomListTile(
                icon: Icons.calendar_month_outlined,
                text: "Date & Distance",
                onTap: (){
                  Get.to(()=> DateAndDistanceScreen());
                },
              ),
              Divider(),
              CustomListTile(
                icon: Icons.people_rounded,
                text: "Refer Friends ",
                onTap: (){},
              ),
              Divider(),
              CustomListTile(
                icon: Icons.rule_folder_sharp,
                text: "Rules & Terms",
                onTap: (){
                  Get.to(()=> RuleAndTermsScreen());
                },
              ),
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

class UserPictureWithButton extends StatelessWidget {
  const UserPictureWithButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  const CustomListTile({
    super.key,
    required this.icon,
    required this.text, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
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
