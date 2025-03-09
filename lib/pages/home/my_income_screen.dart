import 'package:sim/controller/driver_controller.dart';
import 'package:sim/models/payment_model.dart';
import 'package:sim/resources/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyIncomeScreen extends StatefulWidget {
  const MyIncomeScreen({super.key});

  @override
  State<MyIncomeScreen> createState() => _MyIncomeScreenState();
}

class _MyIncomeScreenState extends State<MyIncomeScreen> {
  final _driverController = Get.find<DriverController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_driverController.isPaymentHistoryFetched.value) {
        _driverController.getDriverIncome();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text(
          "My Income",
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
      body: RefreshIndicator(
        onRefresh: () async {
          await _driverController.getDriverIncome();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              //   const SizedBox(height: 10),
              //   Container(
              //     height: 45,
              //     width: Get.width,
              //     decoration: BoxDecoration(
              //       gradient: LinearGradient(
              //         colors: [
              //           AppColors.primaryColor,
              //           const Color.fromARGB(255, 24, 24, 24),
              //         ],
              //       ),
              //     ),
              //     child: const Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: [
              //         Text(
              //           "28 April 2024",
              //           style: TextStyle(
              //             fontWeight: FontWeight.bold,
              //             color: Colors.white,
              //           ),
              //         ),
              //         Text(
              //           "\$280.00",
              //           style: TextStyle(
              //             fontWeight: FontWeight.bold,
              //             color: Colors.white,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),

              const SizedBox(height: 10),
              Obx(() {
                if (_driverController.isloading.value) {
                  return SizedBox(
                    height: Get.height * 0.7,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  );
                }
                if (_driverController.driverIncomeList.isEmpty) {
                  return SizedBox(
                    height: Get.height * 0.7,
                    child: const Center(
                      child: Text("Empty"),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: _driverController.driverIncomeList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final paymentModel =
                        _driverController.driverIncomeList[index];
                    return MyIncomeWidget(paymentModel: paymentModel);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class MyIncomeWidget extends StatelessWidget {
  final PaymentModel paymentModel;
  const MyIncomeWidget({
    super.key,
    required this.paymentModel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.to(() => const MyIncomeWidgetFullDetails());
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 2,
            color: Colors.white,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Pickup Location",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      paymentModel.ride.pickupLocation!.address.length > 40
                          ? paymentModel.ride.pickupLocation!.address
                              .substring(0, 30)
                          : paymentModel.ride.pickupLocation!.address,
                      style: const TextStyle(
                        fontSize: 9,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "N${paymentModel.amount}",
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      paymentModel.ride.paymentStatus ?? "",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 9,
                      ),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Drop Off Location",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      paymentModel.ride.dropoffLocation!.address.length > 40
                          ? paymentModel.ride.dropoffLocation!.address
                              .substring(0, 30)
                          : paymentModel.ride.dropoffLocation!.address,
                      style: const TextStyle(
                        fontSize: 9,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Text(
                  "Express",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
