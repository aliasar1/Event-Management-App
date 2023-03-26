import '../../views/login_screen.dart';
import '../../views/signup_screen.dart';
import '../../views/splash_screen.dart';
import '../views/user_type_views/organizer/organizer_home_screen.dart';
import '../views/user_type_views/participant/participant_home_screen.dart';

class AppRoutes {
  static const String splash = SplashScreen.routeName;
  static const String login = LoginScreen.routeName;
  static const String signup = SignupScreen.routeName;
  static const String organizerHome = OrganizerHomeScreen.routeName;
  static const String participantHome = ParticipantHomeScreen.routeName;
}
