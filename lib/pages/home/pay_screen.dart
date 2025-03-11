import 'package:sim/controller/driver_controller.dart';
import 'package:sim/pages/home/my_ride_list_screen.dart';
import 'package:sim/resources/color_resources.dart';
import 'package:sim/pages/pay/withdraw_earnings_screen.dart';
import 'package:sim/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PayScreen extends StatefulWidget {
  const PayScreen({super.key});

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  final _driverController = Get.find<DriverController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _driverController.getAllBankAccounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: BuildSideBar(),
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text(
          "Pay",
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (context) => GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Get.height * 0.05),
            Obx(() {
              final driverModel = _driverController.driverModel.value;
              String stripeId = driverModel?.stripeAccountId.toString() ?? "";
              return Text(
                "Personal Account: $stripeId",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            }),
            const SizedBox(height: 10),
            Obx(() {
              final driverModel = _driverController.driverModel.value;
              String balance = driverModel?.balance.toString() ?? "";
              return Text(
                "Balance: \$$balance",
                style: const TextStyle(
                  color: Colors.white,
                ),
              );
            }),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  "Refund: \$100.00",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  "( What is it? )",
                  style: TextStyle(
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: AppColors.primaryColor,
                  ),
                  child: const Icon(
                    Icons.done,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  "QR-Payment:",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  "( What is it? )",
                  style: TextStyle(
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            CommonButton(
              text: "Withdraw",
              ontap: () {
                Get.to(() => const WithdrawEarningsScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
