import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../core/routing/route_names.dart';
import '../../core/utils/app_constants.dart';
import '../../main.dart';
import '../../model/data/data_bundles.dart';
import '../../model/data/success_model.dart';
import 'auth_controller.dart';

class DataController extends GetxController {
  DataBundlesModel? dataBundles;

  Future getDataBundles() async {
    try {
      debugPrint("Loading...");
      final token = sharedPreferences!.getString("token");
      final header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };
      const String endPoint = '${AppConstants.mainUrl}/list/data.php';
      final response = await http
          .get(
            Uri.parse(endPoint),
            headers: header,
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception(),
          );
      debugPrint("Data: ${response.body}");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        dataBundles = DataBundlesModel.fromJson(jsonDecode(response.body));
        debugPrint("Data Bundles: ${dataBundles?.network!.length}");
      } else {
        final message = jsonDecode(response.body)["msg"];
        debugPrint("Data: $message");
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

  Future buyData({
    required String? planId,
    required String? networkId,
    required String? phoneNumber,
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
        "network": "$networkId",
        "phone": "$phoneNumber",
        "data_plan": "$planId",
        "ref": "App-$reference",
        "Ported_number": "true",
      };
      // final body = {
      //   "Ported_number": "true",
      //   "mobile_number": "$phoneNumber",
      //   "network": "$networkId",
      //   "plan": "$planId",
      //   "ref": "App-$reference",
      // };
      const String endPoint = '${AppConstants.baseUrl}/data/';
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
        final success = DataSuccessModel.fromJson(jsonDecode(response.body));

        EasyLoading.showSuccess(
          '${success.status}',
          dismissOnTap: true,
          duration: const Duration(seconds: 2),
        );
        Get.toNamed(
          AppRouteNames.dataTransaction,
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
