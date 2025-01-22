import 'package:maresto/data/dataresources/local/theme_local_data_source.dart';

class ThemeRepository {
  final ThemeLocalDataSource themeLocalDataSource;

  ThemeRepository(this.themeLocalDataSource);

  Future<bool> getTheme() async {
    return await themeLocalDataSource.getThemePreference();
  }

  Future<void> setTheme(bool isDark) async {
    await themeLocalDataSource.setThemePreference(isDark);
  }
}
