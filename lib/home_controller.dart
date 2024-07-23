import 'package:cws/NETWORKS/utils.dart';
import 'package:cws/login_screen.dart';
import 'package:cws/user_model.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'NETWORKS/dialog_helper.dart';
import 'NETWORKS/network.dart';
import 'home.dart';

class HomeController extends GetxController {
  var currentPosition = Position(
          latitude: 0.0,
          longitude: 0.0,
          timestamp: DateTime.now(),
          accuracy: 1,
          altitude: 0.0,
          altitudeAccuracy: 0.0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0)
      .obs;
  var isClockedIn = 0.obs;
  var currentAddress = ''.obs;
  var userInfo = User().obs;

  Future<void> ensureLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      status = await Permission.location.request();
      if (!status.isGranted) {
        Get.snackbar('Permission Denied', 'Location permission is required.');
        throw Exception('Location permission denied');
      }
    }
  }

  @override
  onReady() async {
    String? id = await Utility.getStringValue('userId');
    if ((id ?? '').isNotEmpty) {
      Get.offAll(() => HomeScreen());
    } else {
      Get.offAll(() => LoginScreen());
    }

    super.onReady();
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      Get.snackbar(
          'Location Services Disabled', 'Please enable location services.');
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Permission Denied', 'Location permissions are denied');
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Permission Denied',
          'Location permissions are permanently denied, we cannot request permissions.');
      throw Exception('Location permissions are permanently denied.');
    }

    currentPosition.value = await Geolocator.getCurrentPosition();
    await getAddressFromLatLng(currentPosition.value);
  }

  Future<void> getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      currentAddress.value =
          "${place.street}, ${place.locality}, ${place.postalCode}";
    } catch (e) {
      Get.snackbar('Error', 'Failed to get address');
      throw Exception('Failed to get address');
    }
  }

  Future<void> clockIn() async {
    Get.closeAllSnackbars();

    await ensureLocationPermission();
    await getCurrentLocation();
    if (currentAddress.value.isNotEmpty) {
      String? id = await Utility.getStringValue('userId');
      final response = await Network().postRequest(
          endPoint: "clockIn/",
          formData: {"user_id": id, "location": currentAddress.value},
          isLoader: true);
      if (response?.data != null) {
        if (response?.data['status'] == true) {
          isClockedIn.value = 1;
          Get.snackbar(response?.data['message'], '',
              colorText: Colors.green, snackPosition: SnackPosition.TOP);
        }
        getUser();
      } else {
        DialogHelper.showErrorDialog(
            title: "Error", description: response?.data['message']);
      }
      DialogHelper.hideLoading();
    }

  }

  Future<void> clockOut() async {
    Get.closeAllSnackbars();

    String? id = await Utility.getStringValue('userId');
    final response = await Network().postRequest(
        endPoint: "clockOut",
        formData: {"user_id": id, "out_location": currentAddress.value},
        isLoader: true);
    if (response?.data != null) {
      isClockedIn.value = 2;
      if (response?.data['status'] == true) {
        Get.snackbar(response?.data['message'], '',
            colorText: Colors.green, snackPosition: SnackPosition.TOP);
        getUser();
      }
    } else {
      DialogHelper.showErrorDialog(
          title: "Error", description: response?.data['message']);
    }
    DialogHelper.hideLoading();
  }

  Future<void> getUser() async {
    Get.closeAllSnackbars();
    String? id = await Utility.getStringValue('userId');
    final response = await Network().postRequest(
        endPoint: "getUserInfo", formData: {"user_id": id}, isLoader: false);
    if (response?.data != null && response?.data != "") {
      var userData = UserData.fromJson(response?.data);
      userInfo.value = userData.data ?? User();
      if (userInfo.value.status == 'incomplete') {
        isClockedIn.value = 1;
      } else if (userInfo.value.status == 'pending') {
        isClockedIn.value = 2;
      }

      DialogHelper.hideLoading();
    } else {
      DialogHelper.showErrorDialog(
          title: "Error", description: response?.data['message']);
    }
    DialogHelper.hideLoading();
  }

  Future<void> userLogin(dynamic data) async {
    Get.closeAllSnackbars();

    final response = await Network()
        .postRequest(endPoint: "get_emplogin?", formData: data, isLoader: true);
    if (response?.data != null) {
      if (response?.data['message'] == 'Login Successfully') {
        var userData = UserData.fromJson(response?.data);
        userInfo.value = userData.data ?? User();
        Utility.setStringValue('userId', userInfo.value.id ?? '');
        Get.offAll(() => HomeScreen());
      }
      Get.snackbar(response?.data['message'], '',
          colorText: Colors.green, snackPosition: SnackPosition.TOP);
    } else {
      DialogHelper.showErrorDialog(
          title: "Error", description: response?.data['message']);
    }
  }
}
