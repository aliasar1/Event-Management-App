import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/offline_screen.dart';
import 'auth_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SplashController extends GetxController {
  final authController = Get.put(AuthenticateController());

  void initializeAuthentication() {
    authController.checkLoginStatus();
  }

  late RxBool offlineStatus = false.obs;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription _streamSubscription;

  @override
  void onInit() {
    super.onInit();
    checkRealtimeConnection();
    initializeAuthentication();
  }

  void checkRealtimeConnection() {
    _streamSubscription = _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile ||
          event == ConnectivityResult.wifi) {
        if (offlineStatus.value) {
          if (authController.isLoggedIn.value == false) {
            authController.checkLoginStatus();
          }
          offlineStatus.value = false;
          if (WidgetsFlutterBinding.ensureInitialized().firstFrameRasterized) {
            Get.back();
          }
        }
      } else {
        offlineStatus.value = true;
        if (WidgetsFlutterBinding.ensureInitialized().firstFrameRasterized) {
          Get.to(() => const OfflineScreen());
        }
      }
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}
