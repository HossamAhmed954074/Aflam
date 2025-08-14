import 'package:aflam/features/bottom_nav/bottom_nav.dart';
import 'package:aflam/features/details/view/screens/details_screen.dart';
import 'package:go_router/go_router.dart';


class AppRouter {
  static const String bottomNav = '/';
  static const String details = '/details';

   static final GoRouter router = GoRouter(
     routes: [
       GoRoute(
         path: bottomNav,
         builder: (context, state) => const BottomNavegationBarCustom(),
       ),
       GoRoute(
         path: details,
         builder: (context, state) => const DetailsScreen(),
       ),
     ],
   );
}