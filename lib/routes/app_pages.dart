import 'package:event_booking_app/views/login_screen.dart';
import 'package:event_booking_app/views/signup_screen.dart';
import 'package:get/get.dart';

import '../bindings/login_binding.dart';
import '../views/user_type_views/organizer/organizer_home_screen.dart';
import '../views/user_type_views/participant/participant_home_screen.dart';
import '../views/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      bindings: [LoginBinding()],
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => SignupScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.participantHome,
      page: () => ParticipantHomeScreen(),
    ),
    GetPage(
      name: AppRoutes.organizerHome,
      page: () => OrganizerHomeScreen(),
    ),
  ];
}
