import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/utils.dart';

class EventController extends GetxController {
  Rx<bool> isLoading = false.obs;
  final addFormKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final priceController = TextEditingController();

  void toggleLoading({bool showMessage = false, String message = ''}) {
    isLoading.value = !isLoading.value;
    if (showMessage) {
      Utils.showSnackBar(
        message,
        isSuccess: false,
      );
    }
  }

  void addEvent() {}
}
