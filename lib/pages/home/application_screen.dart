import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sim/controller/driver_controller.dart';
import 'package:sim/controller/socket_controller.dart';
import 'package:sim/resources/color_resources.dart';
import 'package:sim/widget/custom_button.dart';

class ApplicationProcessingScreen extends StatefulWidget {
  const ApplicationProcessingScreen({super.key});

  @override
  State<ApplicationProcessingScreen> createState() =>
      _ApplicationProcessingScreenState();
}

class _ApplicationProcessingScreenState
    extends State<ApplicationProcessingScreen> {

  final _driverController = Get.find<DriverController>();
  final _socketController = Get.find<SocketController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)async {
      _driverController.getDriverDetails();
      _socketController.initializeSocket();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // App Bar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                color: Colors.white,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'Application Status',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 40), // Balance the back button
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 220,
                      child: Lottie.asset(
                        'assets/images/application.json',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(47, 92, 180, 95),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Progress indicator
                          Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Status title
                          Obx(
                            () => Text(
                              'Application ${_driverController.driverModel.value?.verificationStatus ?? ""}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Status description
                          Obx(() {
                            final status = _driverController
                                .driverModel.value?.verificationStatus;
                            if (status == "pending") {
                              return const Text(
                                "Your driver application is being processed by our team. We'll notify you as soon as there's an update.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.green,
                                  height: 1.5,
                                ),
                              );
                            }
                            if (status == "rejected") {
                              return const Text(
                                "Your driver application has been rejected",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.green,
                                  height: 1.5,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
              Obx(() {
                final status =
                    _driverController.driverModel.value?.verificationStatus;
                if (status == "pending") {
                  return const SizedBox.shrink();
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: CommonButton(
                      ontap: () async {},
                      child: const Text(
                        "Re-submit application",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }
              }),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
