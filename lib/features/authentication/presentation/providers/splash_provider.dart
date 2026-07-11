import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yhla/features/authentication/data/repositories/fake_startup_repository.dart';
import 'package:yhla/features/authentication/domain/repositories/startup_repository.dart';
import 'package:yhla/features/authentication/domain/usecases/resolve_startup_destination_usecase.dart';
import 'package:yhla/features/authentication/presentation/controllers/splash_controller.dart';

final startupRepositoryProvider = Provider<StartupRepository>((ref) {
  return FakeStartupRepository();
});

final resolveStartupDestinationUseCaseProvider =
    Provider<ResolveStartupDestinationUseCase>((ref) {
  return ResolveStartupDestinationUseCase(ref.watch(startupRepositoryProvider));
});

final splashControllerProvider =
    StateNotifierProvider<SplashController, SplashState>((ref) {
  return SplashController(
    resolveStartupDestinationUseCase:
        ref.watch(resolveStartupDestinationUseCaseProvider),
  );
});