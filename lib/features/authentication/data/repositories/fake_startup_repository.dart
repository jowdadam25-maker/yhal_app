import 'package:yhla/features/authentication/domain/entities/splash_destination.dart';
import 'package:yhla/features/authentication/domain/repositories/startup_repository.dart';

class FakeStartupRepository implements StartupRepository {
  @override
  Future<SplashDestination> resolveStartupDestination() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return SplashDestination.welcome;
  }
}