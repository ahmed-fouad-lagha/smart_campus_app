import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/routes.dart';
import 'config/themes.dart';
import 'services/storage_service.dart';

class SmartCampusApp extends StatelessWidget {
  const SmartCampusApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storageService = Provider.of<StorageService>(context);
    final themeMode = storageService.getThemeMode();

    return MaterialApp.router(
      title: 'Smart Campus Insights',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: _getThemeMode(themeMode),
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }

  ThemeMode _getThemeMode(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
