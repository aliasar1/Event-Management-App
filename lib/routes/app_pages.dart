import 'package:event_booking_app/views/login_screen.dart';
import 'package:event_booking_app/views/signup_screen.dart';
import 'package:get/get.dart';

import '../views/organizer_home_screen.dart';
import '../views/participant_home_screen.dart';
import '../views/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => SignupScreen(),
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
