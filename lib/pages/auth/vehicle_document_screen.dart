import 'package:sim/controller/driver_controller.dart';
import 'package:sim/models/car_model.dart';
import 'package:sim/widget/custom_button.dart';
import 'package:sim/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sim/widget/loader.dart';

class VehicleDocumentScreen extends StatelessWidget {
  final bool isReSubmitting;
  VehicleDocumentScreen({super.key, required this.isReSubmitting});

  final _carNumberController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearOfManController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _numberController = TextEditingController();
  final _colorController = TextEditingController();
  final _driverController = Get.find<DriverController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // bottomSheet: _buildBottomSheet(),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Get.height / 12.5),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      hintText: "Car Number",
                      textController: _carNumberController,
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      hintText: "Model",
                      textController: _modelController,
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      hintText: "Manufacturer",
                      textController: _manufacturerController,
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      hintText: "Year Of Manufacture",
                      textController: _yearOfManController,
                      textInputType: TextInputType.number,
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      hintText: "Color",
                      textController: _colorController,
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      hintText: "Capacity",
                      textController: _numberController,
                      textInputType: TextInputType.number,
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 34),
              Obx(
                () => CommonButton(
                  ontap: _driverController.isloading.value
                      ? () {}
                      : () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          final carModel = Car(
                            carNumber: _carNumberController.text,
                            model: _modelController.text,
                            manufacturer: _manufacturerController.text,
                            yearOfManufacture:
                                int.parse(_yearOfManController.text),
                            color: _colorController.text,
                            capacity: int.parse(_numberController.text),
                          );
                          await _driverController.registerVehicle(
                            carModel: carModel,
                            isReSubmitting: isReSubmitting,
                          );
                        },
                  child: _driverController.isloading.value
                      ? const CarLoader()
                      : const Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 34),
            ],
          ),
        ),
      ),
    );
  }
}
