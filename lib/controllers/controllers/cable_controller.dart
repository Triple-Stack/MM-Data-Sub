import 'dart:async';
import 'dart:convert';
import '/model/cable_tv/cables_model.dart';
import '/model/home/cable/cable_model.dart';
import '/model/home/cable/cable_success.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../core/routing/route_names.dart';
import '../../core/utils/app_constants.dart';
import '../../main.dart';
import 'auth_controller.dart';

class CableTvController extends GetxController {
  CableProvidersModel? cableProvidersModel;

  Future getCables() async {
    try {
      debugPrint("Loading...");
      final token = sharedPreferences!.getString("token");
      final header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };
      const String endPoint = '${AppConstants.mainUrl}/list/cable.php';
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
        cableProvidersModel =
            CableProvidersModel.fromJson(jsonDecode(response.body));
        debugPrint(
            "Cable Providers: ${cableProvidersModel?.cableProviders!.length}");
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

  CableModel? cableModel;
  Future verifyCable({
    required String? provider,
    required String? planName,
    required String? cardNumber,
    required String? amount,
  }) async {
    try {
      EasyLoading.show(
        status: "Loading...",
      );
      final token = sharedPreferences!.getString("token");
      final header = {
        "Content-Type": "application/json",
        "Token": "$token",
      };
      final body = {
        "smart_card_number": "$cardNumber",
        "cablename": "$planName",
        "provider": "$provider",
      };
      const String endPoint =
          '${AppConstants.baseUrl}/cabletv/verify/index.php';
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
      debugPrint("Cable: ${response.body}");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        cableModel = CableModel.fromJson(jsonDecode(response.body));
        EasyLoading.showSuccess(
          '${cableModel?.msg}',
          dismissOnTap: true,
          duration: const Duration(seconds: 2),
        );
        Get.toNamed(
          AppRouteNames.confirmCable,
          arguments: cableModel,
          parameters: {
            "amount": amount!,
            "planName": planName!,
            "card": cardNumber!,
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

  Future payCable({
    required String? cableName,
    required String? planNumber,
    required String? cardNumber,
    required String? reference,
  }) async {
    try {
      EasyLoading.show(status: "Loading...");
      // debugPrint("Loading...");
      final token = sharedPreferences!.getString("token");
      debugPrint("Token...$token");
      final header = {
        "Content-Type": "application/json",
        "Token": "$token",
      };
      final body = {
        "smart_card_number": "$cardNumber",
        "cablename": "$cableName",
        "cableplan": "$planNumber",
        "ref": "App-$reference",
      };
      const String endPoint = '${AppConstants.baseUrl}/cabletv/index.php';
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
      debugPrint("Data Success: ${response.body}");
      final auth = Get.put(AuthController());

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final success = CableSuccessModel.fromJson(jsonDecode(response.body));
        EasyLoading.showSuccess(
          '${success.status}',
          dismissOnTap: true,
          duration: const Duration(seconds: 2),
        );
        Get.toNamed(
          AppRouteNames.cableTransaction,
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
