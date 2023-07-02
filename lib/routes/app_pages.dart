import 'package:get/get.dart';

import '../utils/exports/views_exports.dart';
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
      page: () => const ParticipantHomeScreen(),
    ),
    GetPage(
      name: AppRoutes.participantsEventsHistory,
      page: () => EventsAttendedScreen(),
    ),
    GetPage(
      name: AppRoutes.addEvent,
      page: () => AddEventScreen(),
    ),
    GetPage(
      name: AppRoutes.upcomingEvents,
      page: () => EventScreen(),
    ),
    GetPage(
      name: AppRoutes.favEvents,
      page: () => FavouriteEventScreen(),
    ),
    GetPage(
      name: AppRoutes.offline,
      page: () => const OfflineScreen(),
    ),
    GetPage(
      name: AppRoutes.eventsOrganized,
      page: () => const EventsOrganizedScreen(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
    ),
    GetPage(
      name: AppRoutes.searchEvent,
      page: () => const SearchScreen(),
    ),
  ];
}
