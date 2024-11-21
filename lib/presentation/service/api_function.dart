import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_guru/presentation/service/snackbar.dart';

Future<Map<String, dynamic>> post(
    BuildContext context,
    String url,
    int timeoutDuration,
    Map<String, dynamic> apiArguments,
    String textFail,
    String textSuccess,
    [bool showBar = true]) async {
  try {
    final responses = await http
        .post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(apiArguments),
        )
        .timeout(Duration(seconds: timeoutDuration));

    Map<String, dynamic> data = jsonDecode(responses.body);
    data["statusCode"] = responses.statusCode;

    if (responses.statusCode == 200) {
      if (showBar) {
        showCustomSnackBar(context, textSuccess, true);
      }
      return data;
    } else {
      if (showBar) {
        showCustomSnackBar(context, textFail, false);
      }
      return data;
    }
  } on TimeoutException {
    if (showBar) {
      showCustomSnackBar(context, "Request timed out", false);
    }
    return {};
  }
}

Future<Map<String, dynamic>> get(BuildContext context, String url,
    int timeoutDuration, String textFail, String textSuccess,
    [bool showBar = true]) async {
  try {
    final responses = await http
        .get(Uri.parse(url))
        .timeout(Duration(seconds: timeoutDuration));

    Map<String, dynamic> data = jsonDecode(responses.body);
    data["statusCode"] = responses.statusCode;

    if (responses.statusCode == 200) {
      if (showBar) {
        showCustomSnackBar(context, textSuccess, true);
      }
      return data;
    } else {
      if (showBar) {
        showCustomSnackBar(context, textFail, false);
      }
      return data;
    }
  } on TimeoutException {
    if (showBar) {
      showCustomSnackBar(context, "Request timed out", false);
    }
    return {};
  }
}

Future<Map<String, dynamic>> put(
    BuildContext context,
    String url,
    int timeoutDuration,
    Map<String, dynamic> apiArguments,
    String textFail,
    String textSuccess,
    [bool showBar = true]) async {
  try {
    final responses = await http
        .put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(apiArguments),
        )
        .timeout(Duration(seconds: timeoutDuration));

    Map<String, dynamic> data = jsonDecode(responses.body);
    data["statusCode"] = responses.statusCode;

    if (responses.statusCode == 200) {
      if (showBar) {
        showCustomSnackBar(context, textSuccess, true);
      }
      return data;
    } else {
      if (showBar) {
        showCustomSnackBar(context, textFail, false);
      }
      return data;
    }
  } on TimeoutException {
    if (showBar) {
      showCustomSnackBar(context, "Request timed out", false);
    }
    return {};
  }
}
