import '../../views/login_screen.dart';
import '../../views/signup_screen.dart';
import '../../views/splash_screen.dart';
import '../views/events_attended_history.dart';
import '../views/events_crud_screen.dart';
import '../views/events_screen.dart';
import '../views/fav_events_screen.dart';
import '../views/offline_screen.dart';
import '../views/organized_events_screen.dart';
import '../views/organizer_home_screen.dart';
import '../views/participant_home_screen.dart';
import '../views/profile_view.dart';
import '../views/search_screen.dart';

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
