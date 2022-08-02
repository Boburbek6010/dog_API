import 'package:flutter/material.dart';

class Utils {
  static String getFirstLetters(String fullName) => fullName.isNotEmpty
      ? fullName.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join() : '';

  // FireSnackBar
  static void fireSnackBar(String msg, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.grey.shade400.withOpacity(0.7),
        content: Text(msg, style: const TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.end,),
        duration: const Duration(milliseconds: 1500),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        shape: const StadiumBorder(),
      ),
    );
  }

}
