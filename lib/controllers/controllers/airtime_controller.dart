import 'dart:async';
import 'dart:convert';

import '/controllers/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../core/routing/route_names.dart';
import '../../core/utils/app_constants.dart';
import '../../main.dart';
import '../../model/airtime/success_model.dart';
import '../../model/airtime/telecoms.dart';

class AirtimeController extends GetxController {
  Telecoms? telecomms;
  AirtimeSuccessModel? airtimeModel;

  Future getTelecoms() async {
    try {
      debugPrint("Loading...");
      final token = sharedPreferences!.getString("token");
      final header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };
      const String endPoint = '${AppConstants.mainUrl}/list/airtime.php';
      final response = await http
          .get(
            Uri.parse(endPoint),
            headers: header,
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception(),
          );
      debugPrint("Networks: ${response.body}");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        telecomms = Telecoms.fromJson(jsonDecode(response.body));
        debugPrint("Networks: ${telecomms?.network!.length}");
      } else {
        final message = jsonDecode(response.body)["msg"];
        debugPrint("Networks: $message");
      }
    } on TimeoutException catch (_) {
      // Handle timeout explicitly
      EasyLoading.showError(
        "Request timed out. Please check your internet connection and try again.",
        duration: const Duration(seconds: 1),
      );
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future buyAirtime({
    required String? networkId,
    required String? airtimeType,
    required String? phoneNumber,
    required String? amount,
    required String? reference,
  }) async {
    try {
      EasyLoading.show(
        status: "Loading...",
      );
      debugPrint("Loading...");

      final token = sharedPreferences!.getString("token");
      final header = {
        "Content-Type": "application/json",
        "Token": "$token",
      };
      final body = {
        "network": "$networkId",
        "ported_number": "true",
        "phone": "$phoneNumber",
        "amount": int.tryParse(amount!),
        "airtime_type": "$airtimeType",
        "ref": "App-$reference",
      };
      const String endPoint = '${AppConstants.baseUrl}/airtime/';
      final response = await http
          .post(
            Uri.parse(endPoint),
            headers: header,
            body: jsonEncode(body),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception(),
          );
      debugPrint("Airtime: ${response.body}");
      final auth = Get.put(AuthController());
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final success = AirtimeSuccessModel.fromJson(jsonDecode(response.body));
        EasyLoading.showSuccess(
          '${success.msg}',
          dismissOnTap: true,
          duration: const Duration(seconds: 2),
        );
        Get.toNamed(
          AppRouteNames.airtimeTransaction,
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
    } on TimeoutException catch (_) {
      // Handle timeout explicitly
      EasyLoading.showError(
        "Request timed out. Please check your internet connection and try again.",
        duration: const Duration(seconds: 1),
      );
    } catch (e) {
      debugPrint("Error: $e");
      EasyLoading.showError("$e");
    } finally {
      EasyLoading.dismiss();
    }
  }
}
