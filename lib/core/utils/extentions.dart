import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'enums.dart';

extension ContextExtensions on BuildContext {
  Size get deviceSize => MediaQuery.sizeOf(this);
  Orientation get deviceOrientation => MediaQuery.orientationOf(this);
  void dismissKeyboard() {
    FocusScope.of(this).unfocus();
  }

  void nextFocus(FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(this).requestFocus(nextFocus);
  }
}

extension PinInputFormatter on FilteringTextInputFormatter {
  static TextInputFormatter disallowLeadingZero() {
    return FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*$'));
  }
}

extension NetworkNames on Networks {
  String get properName {
    switch (this) {
      case Networks.mtn:
        return 'MTN';
      case Networks.airtel:
        return 'Airtel';
      case Networks.glo:
        return 'Glo';
      case Networks.etisalat:
        return 'Etisalat';
    }
  }
}

extension DateTimeExtentions on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  String toDate() {
    final formatter = DateFormat('MMM d, y');
    return formatter.format(this);
  }

  String toTime() {
    final formatter = DateFormat('hh:mm a');
    return formatter.format(this);
  }

  String getGreeting() {
    final hour = this.hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning!';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon!';
    } else if (hour >= 17 && hour < 20) {
      return 'Good Evening!';
    } else {
      return 'Night!';
    }
  }
}

extension ListRemoveDuplicates<E> on List<E> {
  List<E> removeDuplicates() {
    return toSet().toList();
  }
}

extension StringExtensions on String {
  String formatPhoneNumber() {
    String phoneNumber = replaceAll(RegExp(r'\s+'), ''); // Remove all spaces
    if (phoneNumber.startsWith('+234')) {
      phoneNumber = phoneNumber.replaceFirst('+234', '0');
    } else if (phoneNumber.startsWith('234')) {
      phoneNumber = phoneNumber.replaceFirst('234', '0');
    }
    return phoneNumber;
  }

  String toFormattedDate() {
    final utcFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    final desiredFormat = DateFormat("yyyy/MM/dd");
    try {
      final dateTime = utcFormat.parseUtc(this);
      return desiredFormat.format(dateTime);
    } on FormatException catch (e) {
      // Handle parsing error (optional)
      debugPrint("Error parsing date: $e");
      return this; // Or return an error message
    }
  }

  String maskAll() {
    return "*" * 16;
  }

  String toQuantity() {
    String? formattedUnit;
    if (isEmpty) {
      throw Exception();
    }
    if (isNotEmpty) {
      formattedUnit = "$this Units";
    }
    return formattedUnit!;
  }

  String? validatePassword() {
    if (isEmpty) {
      return 'Please enter password';
    }
    if (trim().length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  // format currency to Nigerian format
  String toCurrency() {
    final formatter = NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 1,
    );
    return formatter.format(double.parse(this));
  }

  // DateTime to Time only
  String toTimeOnly() {
    // Parse the DateTime string
    DateTime dateTime = DateTime.parse(this);

    // Format the DateTime to show only the time
    return DateFormat('HH:mm').format(dateTime);
  }
}

extension IntExtentions on int {
  bool get isEven => this % 2 == 0;
  bool get isOdd => this % 2 != 0;
  String likeCounts() {
    if (this >= 1000000) {
      // Format for millions (e.g., 1.2m)
      double likesInMillions = this / 1000000.0;
      return '${likesInMillions.toStringAsFixed(1)}m';
    } else if (this >= 1000) {
      // Format for thousands (e.g., 1.2k)
      double likesInThousands = this / 1000.0;
      return '${likesInThousands.toStringAsFixed(1)}k';
    } else {
      // No formatting needed
      return toString();
    }
  }
}
