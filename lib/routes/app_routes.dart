import '../utils/exports/views_exports.dart';

class AppRoutes {
  static const String splash = SplashScreen.routeName;
  static const String login = LoginScreen.routeName;
  static const String signup = SignupScreen.routeName;
  static const String organizerHome = OrganizerHomeScreen.routeName;
  static const String participantHome = ParticipantHomeScreen.routeName;
  static const String participantsEventsHistory =
      EventsAttendedScreen.routeName;
  static const String addEvent = AddEventScreen.routeName;
  static const String upcomingEvents = EventScreen.routeName;
  static const String favEvents = FavouriteEventScreen.routeName;
  static const String offline = OfflineScreen.routeName;
  static const String eventsOrganized = EventsOrganizedScreen.routeName;
  static const String profile = ProfileView.routeName;
  static const String searchEvent = SearchScreen.routeName;
}
