import 'package:yhla/app/app.dart';
import 'package:yhla/app/bootstrap.dart';

export 'package:yhla/app/app.dart';

Future<void> main() async {
  await bootstrap(() => const YhlaApp());
}