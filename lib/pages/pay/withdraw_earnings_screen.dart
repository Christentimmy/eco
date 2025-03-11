import 'package:sim/controller/driver_controller.dart';
import 'package:sim/pages/pay/withdraw_screen.dart';
import 'package:sim/resources/color_resources.dart';
import 'package:sim/pages/pay/add_card_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sim/widget/custom_button.dart';

class WithdrawEarningsScreen extends StatefulWidget {
  const WithdrawEarningsScreen({super.key});

  @override
  State<WithdrawEarningsScreen> createState() => _WithdrawEarningsScreenState();
}

class _WithdrawEarningsScreenState extends State<WithdrawEarningsScreen> {
  final _driverController = Get.find<DriverController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_driverController.isBanksFetched.value) {}
      _driverController.getAllBankAccounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          await _driverController.getAllBankAccounts();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Get.height * 0.02),
                Text(
                  "Choose bank Account",
                  style: TextStyle(
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                Obx(() {
                  if (_driverController.allBankList.isEmpty) {
                    return const SizedBox.shrink();
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _driverController.allBankList.length,
                      itemBuilder: (context, index) {
                        final bankAccount =
                            _driverController.allBankList[index];
                        return GestureDetector(
                          onTap: () {
                            Get.to(() => WithdrawScreen());
                          },
                          child: Container(
                            height: 60,
                            width: Get.width,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Image.asset("assets/images/access.png"),
                                CircleAvatar(
                                  radius: 25,
                                  child: Text(
                                    bankAccount.bankName.substring(0, 2),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      bankAccount.accountHolderName,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "---- ---- ---- ${bankAccount.last4}",
                                      style: const TextStyle(
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                }),
                const SizedBox(height: 10),
                CommonButton(
                  child: const Text(
                    "Add Bank",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  ontap: () => Get.to(() => AddCardScreen()),
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.black,
      title: const Text(
        "Withdraw Earnings",
        style: TextStyle(
          fontSize: 15,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
    );
  }
}
