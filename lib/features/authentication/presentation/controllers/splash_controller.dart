import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yhla/features/authentication/domain/entities/splash_destination.dart';
import 'package:yhla/features/authentication/domain/usecases/resolve_startup_destination_usecase.dart';

class SplashState {
  const SplashState({
    required this.isLoading,
    this.destination,
    this.errorCode,
    this.hasNavigated = false,
  });

  factory SplashState.initial() => const SplashState(isLoading: true);

  final bool isLoading;
  final SplashDestination? destination;
  final String? errorCode;
  final bool hasNavigated;

  SplashState copyWith({
    bool? isLoading,
    SplashDestination? destination,
    String? errorCode,
    bool clearError = false,
    bool clearDestination = false,
    bool? hasNavigated,
  }) {
    return SplashState(
      isLoading: isLoading ?? this.isLoading,
      destination: clearDestination ? null : (destination ?? this.destination),
      errorCode: clearError ? null : (errorCode ?? this.errorCode),
      hasNavigated: hasNavigated ?? this.hasNavigated,
    );
  }
}

class SplashController extends StateNotifier<SplashState> {
  SplashController({
    required ResolveStartupDestinationUseCase resolveStartupDestinationUseCase,
  })  : _resolveStartupDestinationUseCase = resolveStartupDestinationUseCase,
        super(SplashState.initial()) {
    initialize();
  }

  final ResolveStartupDestinationUseCase _resolveStartupDestinationUseCase;

  Future<void> initialize() async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      clearDestination: true,
      hasNavigated: false,
    );

    try {
      final destination = await _resolveStartupDestinationUseCase();
      state = state.copyWith(
        isLoading: false,
        destination: destination,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorCode: 'STARTUP_UNKNOWN_ERROR',
      );
    }
  }

  Future<void> retry() => initialize();

  void markNavigated() {
    if (state.hasNavigated) return;
    state = state.copyWith(hasNavigated: true);
  }
}