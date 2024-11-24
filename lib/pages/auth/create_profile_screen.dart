import 'package:country_code_picker/country_code_picker.dart';
import 'package:eco/Resources/color_resources.dart';
import 'package:eco/pages/auth/bank_details_screen.dart';
import 'package:eco/pages/auth/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateProfileScreen extends StatelessWidget {
  CreateProfileScreen({super.key});

  final Rxn<DateTime> _selectedDate = Rxn<DateTime>();

  Future<void> selectDateOfBirth(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor, // Customize the primary color
              onPrimary: Colors.white, // Text color on selected date
              onSurface: Colors.black, // Default text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // Customize button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      _selectedDate.value = pickedDate;
    }
  }

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _homeAddressController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        height: 90,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          color: Color.fromARGB(255, 22, 22, 22),
        ),
        child: CommonButton(
          text: "Continue",
          ontap: () {
            Get.to(() => BankDetailsScreen());
          },
        ),
      ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Create Your Password",
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Center(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(85),
                      border: Border.all(
                        width: 3,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: SvgPicture.asset(
                        "assets/images/placeholder.svg",
                      ),
                    ),
                  ),
                  Positioned(
                    right: 5,
                    bottom: 5,
                    child: CircleAvatar(
                      radius: 17,
                      backgroundColor: Colors.grey,
                      child: IconButton(
                        onPressed: () {},
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
            ),
            SizedBox(height: Get.height * 0.05),
            CustomTextField(hintText: "First Name", textController: _firstNameController,),
            const SizedBox(height: 15),
            CustomTextField(hintText: "Last Name", textController: _lastNameController,),
            const SizedBox(height: 15),
            Obx(
              () => CustomTextField(
                hintText: _selectedDate.value != null
                    ? DateFormat("MMM dd yyyy").format(_selectedDate.value!)
                    : "Date of birth",
                suffixIcon: Icons.calendar_month,
                textController: _dobController,
                onSuffixClick: () {
                  selectDateOfBirth(context);
                },
              ),
            ),
            const SizedBox(height: 15),
            CustomTextField(
              hintText: "Email",
              suffixIcon: Icons.email,
              textController: _emailController,
            ),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 2,
                  color: Colors.grey,
                ),
              ),
              child: Row(
                children: [
                  CountryCodePicker(
                    onChanged: (value) {
                      print(value);
                    },
                    initialSelection: '+234',
                    textStyle: const TextStyle(color: Colors.white),
                    barrierColor: Colors.transparent,
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    // optional. aligns the flag and the Text left
                    alignLeft: false,
                  ),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Mobile number",
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            CustomTextField(
              hintText: "Home Address",
              suffixIcon: Icons.location_on,
              textController: _homeAddressController,
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  final String hintText;
  IconData? suffixIcon;
  VoidCallback? onSuffixClick;
  final TextEditingController textController;
  CustomTextField({
    super.key,
    required this.hintText,
    this.suffixIcon,
    this.onSuffixClick, required this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: IconButton(
          onPressed: onSuffixClick,
          icon: Icon(
            suffixIcon,
            color: Colors.grey,
          ),
        ),
        hintStyle: const TextStyle(
          fontSize: 12,
          color: Color.fromARGB(176, 158, 158, 158),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            width: 2,
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 2,
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
