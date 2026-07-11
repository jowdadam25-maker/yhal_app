import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yhla/app/router/route_names.dart';
import 'package:yhla/core/constants/assets.dart';
import 'package:yhla/features/authentication/domain/entities/splash_destination.dart';
import 'package:yhla/features/authentication/presentation/controllers/splash_controller.dart';
import 'package:yhla/features/authentication/presentation/providers/splash_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _nameFade;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _logoScale = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _logoFade = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
    );

    _nameFade = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.35, 1.0, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _mapErrorCode(String code) {
    switch (code) {
      case 'STARTUP_TIMEOUT_ERROR':
        return 'Startup timeout';
      case 'STARTUP_UNKNOWN_ERROR':
      default:
        return 'Startup error';
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(splashControllerProvider);
    final size = MediaQuery.sizeOf(context);
    final logoSize = (size.width * 0.52).clamp(180.0, 300.0);

    const bgTop = Color(0xFF140A3A);
    const bgBottom = Color(0xFF070B2B);
    const loaderColor = Color(0xFFFFC72C);

    ref.listenManual(
      splashControllerProvider,
      (previous, next) {
        final destination = next.destination;
        if (destination == null || next.hasNavigated) return;

        final route = switch (destination) {
          SplashDestination.welcome => RouteNames.welcome,
          SplashDestination.completeProfile => RouteNames.completeProfile,
          SplashDestination.home => RouteNames.home,
        };

        ref.read(splashControllerProvider.notifier).markNavigated();
        if (mounted) {
          context.go(route);
        }
      },
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgTop, bgBottom],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FadeTransition(
                  opacity: _logoFade,
                  child: ScaleTransition(
                    scale: _logoScale,
                    child: Image.asset(
                      AppAssets.splashLogo,
                      width: logoSize,
                      height: logoSize,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                if (state.isLoading)
                  const SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(loaderColor),
                    ),
                  )
                else if (state.errorCode != null) ...[
                  Text(
                    _mapErrorCode(state.errorCode!),
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: ref.read(splashControllerProvider.notifier).retry,
                    child: const Text('Retry'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}