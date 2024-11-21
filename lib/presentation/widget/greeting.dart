import 'package:flutter/material.dart';

String getGreeting() {
  final now = DateTime.now();
  final hour = now.hour;

  if (hour >= 5 && hour < 12) {
    return 'Selamat Pagi';
  } else if (hour >= 12 && hour < 15) {
    return 'Selamat Siang';
  } else if (hour >= 15 && hour < 19) {
    return 'Selamat Sore';
  } else {
    return 'Selamat Malam';
  }
}

IconData getGreetingIcons() {
  final now = DateTime.now();
  final hour = now.hour;

  if (hour >= 5 && hour < 18) {
    return Icons.sunny;
  } else {
    return Icons.nightlight;
  }
}
