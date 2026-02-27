import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'home_page.dart';
import 'shared/injection/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ask the platform for the highest available refresh rate after the engine
  // is fully initialised. On iOS ProMotion this is automatic; on Android
  // 90/120 Hz devices it requires the app to opt in explicitly.
  SchedulerBinding.instance.addPostFrameCallback((_) {
    final views = WidgetsBinding.instance.platformDispatcher.views;
    if (views.isNotEmpty) {
      debugPrint('[TradeX] display size: ${views.first.physicalSize}');
    }
  });

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Edge-to-edge mode so the app draws behind the status bar and nav bar.
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor:            Colors.transparent,
    systemNavigationBarColor:  Colors.transparent,
  ));

  await initDependencies();
  runApp(const TradeXApp());
}

class TradeXApp extends StatelessWidget {
  const TradeXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:                    AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme:                    AppTheme.lightTheme,
      home:                     const HomePage(),
    );
  }
}
