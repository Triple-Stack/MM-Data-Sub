import 'dart:async';
import 'dart:convert';
import '/model/home/electricity/electricity_provider.dart';
import '/model/home/electricity/electricity_success.dart';
import '/model/home/electricity/meter_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../core/routing/route_names.dart';
import '../../core/utils/app_constants.dart';
import '../../main.dart';
import 'auth_controller.dart';

class ElectrictyController extends GetxController {
  ElectriciticyProvidersModel? electriciticyProvidersModel;

  Future getElectrics() async {
    try {
      debugPrint("Loading...");
      final token = sharedPreferences!.getString("token");
      final header = {
        "Content-Type": "application/json",
        "Token": "$token",
      };
      const String endPoint = '${AppConstants.mainUrl}/list/electric.php';
      final response = await http
          .get(
            Uri.parse(endPoint),
            headers: header,
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception(),
          );
      debugPrint("Body: ${response.body}");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        electriciticyProvidersModel =
            ElectriciticyProvidersModel.fromJson(jsonDecode(response.body));
        debugPrint(
            "Electriciticy Providers: ${electriciticyProvidersModel?.electriciticyData!.length}");
      } else {
        final message = jsonDecode(response.body)["msg"];
        AppConstants.throwError(message);
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

  MeterModel? meterModel;
  Future verifyMeter({
    required String? providerId,
    required String? provider,
    required String? meterNumber,
    required String? amount,
  }) async {
    try {
      EasyLoading.show(
        status: "Loading...",
      );
      debugPrint("provider...$providerId");
      final token = sharedPreferences!.getString("token");
      final header = {
        "Content-Type": "application/json",
        "Token": "$token",
      };
      final body = {
        "provider": int.tryParse(providerId!),
        "meternumber": int.tryParse(meterNumber!),
        "metertype": "prepaid",
      };
      const String endPoint = '${AppConstants.baseUrl}/electricity/verify/';
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
      debugPrint("Meter: ${response.body}");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        meterModel = MeterModel.fromJson(jsonDecode(response.body));
        EasyLoading.showSuccess(
          '${meterModel?.msg}',
          dismissOnTap: true,
          duration: const Duration(seconds: 2),
        );
        Get.toNamed(
          AppRouteNames.confirmElectricity,
          arguments: meterNumber,
          parameters: {
            "amount": amount!,
            "provider": provider!,
          },
        );
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
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future payBill({
    required String? providerId,
    required String? amount,
    required String? meterNumber,
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
        "provider": int.tryParse(providerId!),
        "meternumber": int.tryParse(meterNumber!),
        "amount": int.tryParse(amount!),
        "metertype": "prepaid",
        "ref": "App-$reference",
      };
      const String endPoint = '${AppConstants.baseUrl}/electricity/';
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
      debugPrint("Data: ${response.body}");
      final auth = Get.put(AuthController());
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final success = ElectricSuccess.fromJson(jsonDecode(response.body));
        EasyLoading.showSuccess(
          '${success.status}',
          dismissOnTap: true,
          duration: const Duration(seconds: 2),
        );
        Get.toNamed(
          AppRouteNames.electricityTransaction,
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
    } finally {
      EasyLoading.dismiss();
    }
  }
}
