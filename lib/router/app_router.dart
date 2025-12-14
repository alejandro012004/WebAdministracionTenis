import 'package:go_router/go_router.dart';
import 'package:practica_tenis_web/presentation/screens/home_screen.dart';
import 'package:practica_tenis_web/presentation/screens/jugadores_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/jugadores',
      builder: (context, state) => const JugadoresScreen(),
    ),
  ],
);
