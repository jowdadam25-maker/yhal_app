import 'package:yhla/features/authentication/domain/entities/splash_destination.dart';

abstract class StartupRepository {
  Future<SplashDestination> resolveStartupDestination();
}
