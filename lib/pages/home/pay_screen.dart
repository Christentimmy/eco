import 'package:eco/Resources/color_resources.dart';
import 'package:eco/pages/auth/sign_up_screen.dart';
import 'package:eco/pages/pay/withdraw_earnings_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PayScreen extends StatelessWidget {
  const PayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Get.height * 0.05),
            Text(
              "Personal Account: 90235435",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Balance: \$800.00",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
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
                  child: Icon(
                    Icons.done,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
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
                Get.to(()=> WithdrawEarningsScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
