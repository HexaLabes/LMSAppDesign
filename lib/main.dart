import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/app_state_provider.dart';
import 'screens/splash/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
      ],
      child: const LMSPrepApp(),
    ),
  );
}

class LMSPrepApp extends StatelessWidget {
  const LMSPrepApp({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();

    return MaterialApp(
      title: 'CIT Prep LMS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getLightTheme(state.primaryColor, state.accentColor),
      darkTheme: AppTheme.getDarkTheme(state.primaryColorLight, state.accentColor),
      themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}
