// lib/core/router.dart

import 'package:go_router/go_router.dart';
import '../screens/about_screen.dart';
import '../screens/home_screen.dart';
import '../screens/parts_screen.dart';
import '../screens/topics_screen.dart';
import '../screens/quiz_screen.dart';
import '../screens/result_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/about',
      name: 'about',
      builder: (context, state) => const AboutScreen(),
    ),
    GoRoute(
      path: '/subject/:subjectId',
      name: 'parts',
      builder: (context, state) => PartsScreen(
        subjectId: state.pathParameters['subjectId']!,
      ),
    ),
    GoRoute(
      path: '/subject/:subjectId/:partId',
      name: 'topics',
      builder: (context, state) => TopicsScreen(
        subjectId: state.pathParameters['subjectId']!,
        partId: state.pathParameters['partId']!,
      ),
    ),
    GoRoute(
      path: '/quiz/:subjectId/:partId/:topicId',
      name: 'quiz',
      builder: (context, state) => QuizScreen(
        subjectId: state.pathParameters['subjectId']!,
        partId: state.pathParameters['partId']!,
        topicId: state.pathParameters['topicId']!,
      ),
    ),
    GoRoute(
      path: '/result',
      name: 'result',
      builder: (context, state) => const ResultScreen(),
    ),
  ],
);
