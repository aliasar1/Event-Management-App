import 'package:event_booking_app/views/events_crud_screen.dart';
import 'package:event_booking_app/views/fav_events_screen.dart';
import 'package:event_booking_app/views/login_screen.dart';
import 'package:event_booking_app/views/offline_screen.dart';
import 'package:event_booking_app/views/profile_view.dart';
import 'package:event_booking_app/views/search_screen.dart';
import 'package:event_booking_app/views/signup_screen.dart';
import 'package:get/get.dart';

import '../views/events_attended_history.dart';
import '../views/events_screen.dart';
import '../views/organized_events_screen.dart';
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
      page: () => EventsOrganizedScreen(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileView(),
    ),
    GetPage(
      name: AppRoutes.searchEvent,
      page: () => SearchScreen(),
    ),
  ];
}
