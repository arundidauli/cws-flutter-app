import 'dart:async';

//import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Created by arun android

class Utility {
  late SharedPreferences prefs;

  getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  static setStringValue(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  clearAll() async {
    prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  saveIntValue(String key, int value) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  saveDoubleValue(String key, double value) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }

  saveBoolValue(String key, bool value) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  saveStringListValue(String key, List<String> value) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, value);
  }

  static Future<String?> getStringValue(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(value);
  }

  Future<int?> getIntValue(String value) async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getInt(value);
  }

  Future<double?> getDoubleValue(String value) async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(value);
  }

  Future<bool?> getBoolValue(String value) async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getBool(value);
  }

  Future<List<String>?> getListValue(String value) async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(value);
  }


  static void showAlert(BuildContext context, String text, String des) {
    Widget continueButton = TextButton(
      child: const Text("Got it"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(
        text,
        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
      ),
      content: Text(des),
      actions: [
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
