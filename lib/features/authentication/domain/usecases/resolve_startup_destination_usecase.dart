import 'package:yhla/features/authentication/domain/entities/splash_destination.dart';
import 'package:yhla/features/authentication/domain/repositories/startup_repository.dart';

class ResolveStartupDestinationUseCase {
  ResolveStartupDestinationUseCase(this._repository);

  final StartupRepository _repository;

  Future<SplashDestination> call() {
    return _repository.resolveStartupDestination();
  }
}