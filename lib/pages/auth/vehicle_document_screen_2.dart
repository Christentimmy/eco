import 'package:sim/controller/driver_controller.dart';
import 'package:sim/pages/auth/upload_eac_doc_screen.dart';
import 'package:sim/pages/home/application_screen.dart';
import 'package:sim/resources/color_resources.dart';
import 'package:sim/pages/auth/personal_document_screen.dart';
import 'package:sim/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sim/widget/snack_bar.dart';

class VehichleDocumentScreen2 extends StatelessWidget {
  final bool isReSubmitting;
  VehichleDocumentScreen2({super.key, required this.isReSubmitting});
  final RxBool _isloading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomSheet: Container(
        height: 120,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          color: Color.fromARGB(255, 22, 22, 22),
        ),
        child: Obx(
          () => CommonButton(
            ontap: _isloading.value
                ? () {}
                : () async {
                    _isloading.value = true;
                    final driverController = Get.find<DriverController>();
                    await driverController.getDriverDetails();
                    final vehicle =
                        driverController.driverModel.value?.vehicleDocuments;

                    List<String> missingDocs = [];

                    if (vehicle == null) {
                      missingDocs.add("Vehicle documents not found.");
                    } else {
                      if (vehicle.vehicleRegistration?.isEmpty == true) {
                        missingDocs.add("Vehicle Registration");
                      }
                      if (vehicle.insurancePolicy?.isEmpty == true) {
                        missingDocs.add("Insurance Policy");
                      }
                      if (vehicle.ownerCertificate?.isEmpty == true) {
                        missingDocs.add("Owner Certificate");
                      }
                      if (vehicle.puc?.isEmpty == true) {
                        missingDocs.add("PUC (Pollution Under Control)");
                      }
                    }

                    if (missingDocs.isNotEmpty) {
                      CustomSnackbar.showErrorSnackBar(
                          "Missing Documents: ${missingDocs.join(", ")}");
                      _isloading.value = false;
                      return;
                    }

                    _isloading.value = false;
                    if (isReSubmitting) {
                      await driverController.reSubmitApplication();
                      return;
                    }

                    Get.offAll(() => const ApplicationProcessingScreen());
                  },
            child: _isloading.value
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text(
          "Vehicle Document",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Get.height * 0.05),
            UploadDocCard(
              firstText: "Rc Book",
              secondText: "Vehicle registration",
              ontap: () {
                Get.to(
                  () => UploadEacDocScreen(
                    title: "Vehicle registration",
                    isVehicleDoc: true,
                    isReSubmitting: isReSubmitting,
                  ),
                );
              },
            ),
            UploadDocCard(
              firstText: "INSURANCE POLICY",
              secondText: "A driving license is an official Id",
              ontap: () {
                Get.to(
                  () => UploadEacDocScreen(
                    title: "INSURANCE POLICY",
                    isVehicleDoc: true,
                    isReSubmitting: isReSubmitting,
                  ),
                );
              },
            ),
            UploadDocCard(
              firstText: "OWNER CERTIFICATE",
              secondText: "A passport is a travel document",
              ontap: () {
                Get.to(
                  () => UploadEacDocScreen(
                    title: "OWNER CERTIFICATE",
                    isVehicleDoc: true,
                    isReSubmitting: isReSubmitting,
                  ),
                );
              },
            ),
            UploadDocCard(
              firstText: "PUC",
              secondText: "Incorrect document type",
              ontap: () {
                Get.to(
                  () => UploadEacDocScreen(
                    title: "PUC",
                    isVehicleDoc: true,
                    isReSubmitting: isReSubmitting,
                  ),
                );
              },
            ),
            const SizedBox(height: 25),
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text:
                          "By continuing, I confirm that I have read & agree to the\n",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    TextSpan(
                      text: "Terms & conditions",
                      style: TextStyle(
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const TextSpan(
                        text: " and ",
                        style: TextStyle(
                          color: Colors.grey,
                        )),
                    TextSpan(
                      text: "Privacy policy",
                      style: TextStyle(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
