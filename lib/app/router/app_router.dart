import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yhla/app/router/route_names.dart';
import 'package:yhla/features/authentication/presentation/pages/splash_page.dart';

final router = GoRouter(
  initialLocation: RouteNames.splash,
  routes: [
    GoRoute(
      path: RouteNames.splash,
      name: RouteNames.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: RouteNames.welcome,
      name: RouteNames.welcome,
      builder: (context, state) => const _WelcomePlaceholderPage(),
    ),
    GoRoute(
      path: RouteNames.completeProfile,
      name: RouteNames.completeProfile,
      builder: (context, state) => const _CompleteProfilePlaceholderPage(),
    ),
    GoRoute(
      path: RouteNames.home,
      name: RouteNames.home,
      builder: (context, state) => const _HomePlaceholderPage(),
    ),
  ],
);

class _WelcomePlaceholderPage extends StatelessWidget {
  const _WelcomePlaceholderPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Welcome Page (Placeholder)')),
    );
  }
}

class _CompleteProfilePlaceholderPage extends StatelessWidget {
  const _CompleteProfilePlaceholderPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Complete Profile Page (Placeholder)')),
    );
  }
}

class _HomePlaceholderPage extends StatelessWidget {
  const _HomePlaceholderPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Home Page (Placeholder)')),
    );
  }
}