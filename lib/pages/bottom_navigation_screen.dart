import 'package:sim/pages/home/my_income_screen.dart';
import 'package:sim/pages/home/my_ride_list_screen.dart';
import 'package:sim/pages/home/pay_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sim/pages/home/ride_history_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavigationScreen extends StatelessWidget {
  BottomNavigationScreen({super.key});

  final RxInt _selectedIndex = 0.obs;

  final _pages = [
    const MyRideListScreen(),
    const MyIncomeScreen(),
    const RideHistoryScreen(),
    const PayScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() => _pages[_selectedIndex.value]),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 5),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 17, 17, 17),
          borderRadius: BorderRadius.circular(25),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Obx(
          () => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Colors.grey,
            elevation: 0,
            showUnselectedLabels: false,
            currentIndex: _selectedIndex.value,
            enableFeedback: false,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            onTap: (value) {
              _selectedIndex.value = value;
            },
            backgroundColor: const Color.fromARGB(255, 17, 17, 17),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: "Ride",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  FontAwesomeIcons.moneyBill,
                  size: 20,
                ),
                label: "My Income",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.drive_eta_outlined),
                label: "Ride History",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.payment),
                label: "Pay",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
