import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '/model/home/exam/exam_success_model.dart';
import '/model/home/exam/exams_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../core/routing/route_names.dart';
import '../../core/utils/app_constants.dart';
import '../../main.dart';
import 'auth_controller.dart';

class EducationController extends GetxController {
  ExamsModel? examsModel;

  Future getExams() async {
    try {
      debugPrint("Loading...");
      final token = sharedPreferences!.getString("token");
      final header = {
        "Content-Type": "application/json",
        "Token": "$token",
      };
      const String endPoint = '${AppConstants.mainUrl}/list/exam.php';
      final response = await http
          .get(
            Uri.parse(endPoint),
            headers: header,
          )
          .timeout(
            const Duration(seconds: 60),
          );
      debugPrint("Body: ${response.body}");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        examsModel = ExamsModel.fromJson(jsonDecode(response.body));
        debugPrint("Exams: ${examsModel?.examCards!.length}");
      } else {
        final message = jsonDecode(response.body)["msg"];
        AppConstants.throwError(message);
      }
    } on SocketException {
      EasyLoading.showError("No internet connection.");
    } on HttpException {
      EasyLoading.showError("Failed to fetch data, try again");
    } on FormatException {
      EasyLoading.showError("Response format error.");
    } on TimeoutException {
      EasyLoading.showError("Request timed out. Try again.");
    } catch (e) {
      EasyLoading.showError("Something went wrong");
    }
  }

  Future buyExam({
    required String? providerCode,
    required String? reference,
  }) async {
    try {
      EasyLoading.show(
        status: "Loading...",
      );
      // debugPrint("Loading...");
      final token = sharedPreferences!.getString("token");
      final header = {
        "Content-Type": "application/json",
        "Token": "$token",
      };
      final body = {
        "provider": int.tryParse(providerCode!),
        "quantity": 1,
        "ref": "App-$reference",
      };
      const String endPoint = '${AppConstants.baseUrl}/exam/';
      final response = await http
          .post(
            Uri.parse(endPoint),
            headers: header,
            body: jsonEncode(body),
          )
          .timeout(
            const Duration(seconds: 60),
          );
      debugPrint("Data Success: ${response.body}");
      final auth = Get.put(AuthController());

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final success = ExamSuccessModel.fromJson(jsonDecode(response.body));

        EasyLoading.showSuccess(
          '${success.status}',
          dismissOnTap: true,
          duration: const Duration(seconds: 2),
        );
        Get.toNamed(
          AppRouteNames.examTransaction,
          arguments: success,
        );

        await auth.getUser();
      } else {
        debugPrint("Error: ${response.body}");
        final message = jsonDecode(response.body)["msg"];
        EasyLoading.showError(
          message,
          duration: const Duration(seconds: 3),
        );
      }
    } on SocketException {
      EasyLoading.showError("No internet connection.");
    } on HttpException {
      EasyLoading.showError("Failed to fetch data, try again");
    } on FormatException {
      EasyLoading.showError("Response format error.");
    } on TimeoutException {
      EasyLoading.showError("Request timed out. Try again.");
    } catch (e) {
      EasyLoading.showError("Something went wrong");
    } finally {
      EasyLoading.dismiss();
    }
  }
}
