import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:event_booking_app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/offline_screen.dart';

class SplashController extends GetxController {
  AuthenticateController controller = Get.find();

  late RxBool offlineStatus = false.obs;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription _streamSubscription;

  @override
  void onInit() {
    super.onInit();
    checkRealtimeConnection();
  }

  void checkRealtimeConnection() {
    // _streamSubscription = _connectivity.onConnectivityChanged.listen((event) {
    //   if (event == ConnectivityResult.mobile ||
    //       event == ConnectivityResult.wifi) {
    //     if (offlineStatus.value) {
    //       if (controller.isLoggedIn.value) {
    //         controller.checkLoginStatus();
    //       }
    //       offlineStatus.value = false;
    //       if (WidgetsFlutterBinding.ensureInitialized().firstFrameRasterized) {
    //         Get.back();
    //       }
    //     }
    //   } else {
    //     offlineStatus.value = true;
    //     if (WidgetsFlutterBinding.ensureInitialized().firstFrameRasterized) {
    //       Get.to(() => const OfflineScreen());
    //     }
    //   }
    // });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}
