import 'package:event_booking_app/controllers/auth_controller.dart';
import 'package:get/get.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthenticateController(), fenix: true);
  }
}
