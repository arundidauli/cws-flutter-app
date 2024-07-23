import 'package:cws/NETWORKS/utils.dart';
import 'package:cws/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final homeController = Get.find<HomeController>();

  getUser() {
    Future.delayed(
      Duration.zero,
      () {
        homeController.getUser();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'images/logo.png',
          ),
        ),
        title: const Text('Time Sheet'),
        actions: [
          IconButton(
              onPressed: () {
                getUser();
              },
              icon: const Icon(
                Icons.refresh,
              ))
        ],
      ),
      body: Obx(() => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  homeController.userInfo.value.firstName ?? 'N/A',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                '${DateFormat('EEEE, hh:mm a').format(DateTime.now())}',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.lightBlueAccent),
              ),
              ListTile(
                title: const Text(
                  'In Time',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                trailing: Text(
                  '${homeController.userInfo.value.inTime ?? 'N/A'}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
              ListTile(
                title: const Text(
                  'Out Time',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                trailing: Text(
                  homeController.userInfo.value.outTime ?? 'N/A',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                height: 20,
                width: double.infinity,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    homeController.currentAddress.value.isNotEmpty ? homeController.currentAddress.value : homeController.userInfo.value.location ?? ''),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: homeController.isClockedIn.value == 2
                        ? Colors.grey
                        : Colors.lightBlue),
                onPressed: () async {
                  if (homeController.userInfo.value.status == 'incomplete') {
                    await homeController.clockOut();
                  } else if (homeController.userInfo.value.status !=
                      'pending') {
                    await homeController.clockIn();
                  }
                },
                child: Text(
                  homeController.isClockedIn.value == 1
                      ? 'Clock Out'
                      : 'Clock In',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                  onPressed: () {
                    Utility().clearAll();
                    Get.offAll(() => LoginScreen());
                  },
                  child: const Text("Logout"))
            ],
          )),
    );
  }
}
