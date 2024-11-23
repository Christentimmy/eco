import 'package:eco/pages/my_income_screen.dart';
import 'package:eco/pages/my_ratings_screen.dart';
import 'package:eco/pages/my_ride_list_screen.dart';
import 'package:eco/pages/pay_screen.dart';
import 'package:eco/pages/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavigationScreen extends StatelessWidget {
  BottomNavigationScreen({super.key});

  final RxInt _selectedIndex = 0.obs;

  final _pages = [
    MyRideListScreen(),
    MyIncomeScreen(),
    MyRatingsScreen(),
    PayScreen(),
    SettingScreen(),
    // Container(color: Colors.purple),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(()=> _pages[_selectedIndex.value]),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 17, 17, 17),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Obx(
          () => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Colors.grey,
            elevation: 0,
            currentIndex: _selectedIndex.value,
            enableFeedback: false,
            onTap: (value) {
              _selectedIndex.value = value;
            },
            backgroundColor: const Color.fromARGB(255, 17, 17, 17),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.payment),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
