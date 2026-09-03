import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/main_navigation_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style for seamless dark cyberpunk theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF040711),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const ScanverseApp());
}

class ScanverseApp extends StatelessWidget {
  const ScanverseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SCANVERSE — Interactive Radiology Experience',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainNavigationShell(),
    );
  }
}
