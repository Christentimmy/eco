import 'dart:io';
import 'package:sim/controller/driver_controller.dart';
import 'package:sim/utils/image_picker.dart';
import 'package:sim/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sim/widget/loader.dart';

class UploadEacDocScreen extends StatelessWidget {
  final String title;
  final bool isVehicleDoc;
  final VoidCallback? resubmitNextScreen;
  final bool isReSubmitting;
  UploadEacDocScreen({
    super.key,
    required this.title,
    required this.isVehicleDoc,
    this.resubmitNextScreen,
    required this.isReSubmitting,
  });

  final Rxn<File> _image = Rxn<File>();

  void selectImageForUser() async {
    File? im = await pickImage();
    if (im != null) {
      _image.value = im;
    }
  }

  final _driverController = Get.find<DriverController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: Get.height * 0.05),
            Center(
              child: Text(
                "Please take a clear photo of the\nentire document",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => GestureDetector(
                onTap: () {
                  selectImageForUser();
                },
                child: SizedBox(
                  height: Get.height * 0.6,
                  width: Get.width,
                  child: _image.value != null
                      ? Image.file(
                          _image.value!,
                          fit: BoxFit.cover,
                          height: Get.height * 0.6,
                        )
                      : SvgPicture.asset(
                          "assets/images/placeholder.svg",
                          fit: BoxFit.cover,
                          height: Get.height * 0.6,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => SizedBox(
                width: Get.width * 0.6,
                child: CommonButton(
                  ontap: _driverController.isloading.value
                      ? () {}
                      : () async {
                          String customTitle =
                              title.toLowerCase().replaceAll(" ", "_");
                          if (_image.value == null) {
                            selectImageForUser();
                          } else {
                            if (isVehicleDoc) {
                              await _driverController.uploadVehicleDocs(
                                imageFile: _image.value!,
                                title: customTitle,
                              );
                            } else {
                              await _driverController.uploadPersonalDoc(
                                imageFile: _image.value!,
                                title: customTitle,
                                resubmitNextScreen: resubmitNextScreen,
                                isReSubmitting: isReSubmitting,
                              );
                            }
                          }
                        },
                  child: _driverController.isloading.value
                      ? const CarLoader()
                      : Text(
                          _image.value == null
                              ? "Take a photo"
                              : "Upload Photo",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
