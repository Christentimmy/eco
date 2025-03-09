import 'dart:io';
import 'package:sim/controller/driver_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sim/resources/color_resources.dart';
import 'package:sim/utils/image_picker.dart';
import 'package:sim/widget/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final _driverController = Get.find<DriverController>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final Rxn<File> _image = Rxn<File>();

  void selectImageForUser() async {
    File? im = await pickImage();
    if (im != null) {
      _image.value = im;
    }
  }

  @override
  Widget build(BuildContext context) {
    firstNameController.text =
        _driverController.userModel.value?.firstName ?? "";
    lastNameController.text = _driverController.userModel.value?.lastName ?? "";
    phoneNumberController.text =
        _driverController.userModel.value?.phoneNumber ?? "";
    emailController.text = _driverController.userModel.value?.email ?? "";
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text(
          "Profile",
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Get.height * 0.01),
             _buildImageWidget(),
              SizedBox(height: Get.height * 0.08),
              _buildTextField("First Name", firstNameController),
              _buildTextField("Last Name", lastNameController),
              _buildTextField("Phone Number", phoneNumberController),
              _buildTextField("Email Address", emailController),
              SizedBox(height: Get.height * 0.05),
              Obx(
                () => CommonButton(
                  child: _driverController.isEditLoading.value
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Save",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                  ontap: () async {
                    await _driverController.updateUserDetails(
                      firstName: firstNameController.text.trim(),
                      lastName: lastNameController.text.trim(),
                      phoneNumber: phoneNumberController.text.trim(),
                      email: emailController.text.trim(),
                      profilePicture: _image.value,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Center _buildImageWidget() {
    return Center(
      child: Stack(
        children: [
          Container(
            height: 110,
            width: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(85),
              border: Border.all(
                width: 3,
                color: AppColors.primaryColor,
              ),
            ),
            child: Obx(() {
              if (_driverController.isloading.value) {
                return const CircularProgressIndicator();
              }
              String image =
                  _driverController.userModel.value?.profilePicture ?? "";
              return ClipRRect(
                borderRadius: BorderRadius.circular(80),
                child: _image.value != null
                    ? Image.file(
                        _image.value!,
                        fit: BoxFit.cover,
                      )
                    : Image.network(image),
              );
            }),
          ),
          Positioned(
            right: 5,
            bottom: 5,
            child: CircleAvatar(
              radius: 17,
              backgroundColor: Colors.grey,
              child: IconButton(
                onPressed: selectImageForUser,
                icon: Icon(
                  Icons.camera,
                  size: 17,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: AppColors.primaryColor,
          ),
        ),
        TextFormField(
          style: const TextStyle(
            color: Colors.white,
          ),
          controller: controller,
          decoration: InputDecoration(
            hintText: label,
            hintStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white70),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
