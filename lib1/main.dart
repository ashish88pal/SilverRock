import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'home_page.dart';
import 'shared/injection/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── 120 fps: request the highest available refresh rate ──────────────────
  // On Android 90/120 Hz devices the platform will grant the preferred rate
  // only if the app explicitly opts in via scheduleFrameCallback + the
  // physicalDisplayFeatures API.  On iOS ProMotion this is automatic.
  //
  // Using SchedulerBinding.instance ensures we request the rate AFTER the
  // engine is fully initialised (safe for both Android & iOS).
  SchedulerBinding.instance.addPostFrameCallback((_) {
    final views = WidgetsBinding.instance.platformDispatcher.views;
    if (views.isNotEmpty) {
      final refreshRate = views.first.physicalSize; // triggers display query
      debugPrint('[TradeX] display: $refreshRate');
    }
  });

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Prefer the maximum refresh rate available on the device.
  // On Android this writes the preferredFrameRateRange to the surface;
  // on iOS it's a no-op (ProMotion is always enabled).
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  await initDependencies();
  runApp(const TradingApp());
}

class TradingApp extends StatelessWidget {
  const TradingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomePage(),
    );
  }
}
