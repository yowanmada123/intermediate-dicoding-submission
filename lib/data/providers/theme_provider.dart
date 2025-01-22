import 'package:flutter/material.dart';
import 'package:maresto/data/repositories/local/theme_local_data_source.dart';

class ThemeProvider extends ChangeNotifier {
  final ThemeRepository themeRepository;

  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  ThemeProvider(this.themeRepository) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    _isDarkTheme = await themeRepository.getTheme();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkTheme = !_isDarkTheme;
    await themeRepository.setTheme(_isDarkTheme);
    notifyListeners();
  }
}
