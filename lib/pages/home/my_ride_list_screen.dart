import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sim/controller/auth_controller.dart';
import 'package:sim/controller/driver_controller.dart';
import 'package:sim/controller/socket_controller.dart';
import 'package:sim/controller/storage_controller.dart';
import 'package:sim/models/ride_model.dart';
import 'package:sim/pages/auth/sign_up_screen.dart';
import 'package:sim/pages/home/ride_history_screen.dart';
import 'package:sim/pages/settings/faq_screen.dart';
import 'package:sim/pages/settings/setting_screen.dart';
import 'package:sim/resources/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sim/widget/custom_button.dart';

class MyRideListScreen extends StatefulWidget {
  const MyRideListScreen({super.key});

  @override
  State<MyRideListScreen> createState() => _MyRideListScreenState();
}

class _MyRideListScreenState extends State<MyRideListScreen> {
  final RxString _status = "".obs;
  final _driverController = Get.find<DriverController>();

  @override
  void initState() {
    super.initState();
    _status.value = _driverController.driverModel.value?.status ?? "offline";
    saveUserOneSignalId();
  }

  void saveUserOneSignalId() async {
    String? subId = OneSignal.User.pushSubscription.id;
    if (subId != null) {
      await _driverController.saveUserOneSignalId(oneSignalId: subId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildFloatingButton(context: context),
      backgroundColor: Colors.black,
      drawer: BuildSideBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          return await _driverController.getAllRideRequests();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SizedBox(height: Get.height / 10.5),
              Row(
                children: [
                  Builder(
                    builder: (context) => GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.menu),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 47,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(
                            () => GestureDetector(
                              onTap: () {
                                _status.value = "offline";
                                _driverController.updateDriverStatus(
                                  status: "offline",
                                );
                              },
                              child: Container(
                                height: 40,
                                width: Get.width / 2.55,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: _status.value == "offline"
                                      ? Colors.red
                                      : null,
                                ),
                                child: Text(
                                  "Offline",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: _status.value == "offline"
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Obx(
                            () => GestureDetector(
                              onTap: () {
                                _status.value = "available";
                                _driverController.updateDriverStatus(
                                  status: "available",
                                );
                              },
                              child: Container(
                                height: 40,
                                width: Get.width / 2.55,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: _status.value == "available" ||
                                          _status.value == "busy"
                                      ? AppColors.primaryColor
                                      : null,
                                ),
                                child: Text(
                                  "Online",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: _status.value == "available"
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Obx(() {
                  if (_driverController.isloading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (_status.value == "offline") {
                    return const EmptyListWidget();
                  } else if (_driverController.allRideRequests.isEmpty) {
                    return const Center(
                      child: Text(
                        "No requests found",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: _driverController.allRideRequests.length,
                      itemBuilder: (context, index) {
                        Ride ride = _driverController.allRideRequests[index];
                        print(ride.status);
                        return ListCardWidget(ride: ride);
                      },
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FloatingActionButton _buildFloatingButton({
    required BuildContext context,
  }) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              height: 200,
              width: Get.width,
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 20,
              ),
              decoration: const BoxDecoration(
                color: Color(0xff22272B),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    "Today’s Summary",
                    style: TextStyle(
                      fontSize: 23,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 35),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Today's Total Trip",
                            style: TextStyle(
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.car,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "10 Trips",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Today's Total Trip",
                            style: TextStyle(
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.wallet,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "₦5,456.00",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
      backgroundColor: AppColors.primaryColor,
      child: Image.asset(
        "assets/images/float.png",
        width: 25,
      ),
    );
  }
}

class BuildSideBar extends StatelessWidget {
  BuildSideBar({super.key});

  final _driverController = Get.find<DriverController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 19, 19, 19),
            ),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                    _driverController.userModel.value?.profilePicture ?? "",
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => Text(
                        "${_driverController.userModel.value?.firstName} ${_driverController.userModel.value?.lastName}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        Text(
                          "${_driverController.driverModel.value?.reviews?.averageRating ?? 0}(${_driverController.driverModel.value?.reviews?.totalRatings?? 0})",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Builder(
                  builder: (context) {
                    return IconButton(
                      onPressed: () {
                        Scaffold.of(context).closeDrawer();
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text(
              'Settings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Get.to(() => SettingScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text(
              'Rides',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              if (Get.currentRoute == "/RideHistoryScreen") {
                Navigator.pop(context);
              } else {
                Get.to(() => const RideHistoryScreen());
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_support_rounded),
            title: const Text(
              'FAQ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Get.to(() => FaqScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_support_rounded),
            title: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () async {
              final storageController = Get.find<StorageController>();
              final authController = Get.find<AuthController>();
              final socketService = Get.find<SocketController>();
              socketService.disconnectSocket();
              await authController.logout();
              await storageController.deleteToken();
              Get.offAll(() => SignUpScreen());
              _driverController.clearUserData();
            },
          ),
        ],
      ),
    );
  }
}

class ListCardWidget extends StatelessWidget {
  final Ride ride;
  ListCardWidget({super.key, required this.ride});

  final _driverController = Get.find<DriverController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.to(() => const ListCardDetailsScreen());
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
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              minTileHeight: 45,
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.location_on,
                color: AppColors.primaryColor,
              ),
              horizontalTitleGap: 5,
              title: const Text(
                "Pickup Location",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                ride.pickupLocation?.address ?? "",
                style: const TextStyle(
                  fontSize: 9,
                  color: Colors.grey,
                ),
              ),
            ),
            ListTile(
              minTileHeight: 45,
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.location_on,
                color: AppColors.primaryColor,
              ),
              horizontalTitleGap: 5,
              title: const Text(
                "Drop Off Location",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                ride.dropoffLocation?.address ?? "",
                style: const TextStyle(
                  fontSize: 9,
                  color: Colors.grey,
                ),
              ),
            ),
            const Divider(),
            Row(
              children: [
                SizedBox(
                  width: Get.width / 2.5,
                  height: Get.height * 0.06,
                  child: Obx(
                    () => CommonButton(
                      child: _driverController.isAcceptRideLoading.value
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Accept",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                      ontap: () async {
                        await _driverController.acceptRideRequest(
                          rideId: ride.id ?? "",
                          ride: ride,
                        );
                        // Get.to(() => const ListCardDetailsScreen());
                      },
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class EmptyListWidget extends StatelessWidget {
  const EmptyListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/images/loc.svg",
          width: 250,
        ),
        const SizedBox(height: 15),
        Text(
          "Turn your location on and\nstatus to online",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Your location info is needed to find the ride\nrequests in your current area",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: Get.height / 10)
      ],
    );
  }
}
