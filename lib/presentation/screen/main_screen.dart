import 'package:flutter/material.dart';
import 'package:maresto/data/providers/index_nav_provider.dart';
import 'package:maresto/presentation/screen/favorite_sreen.dart';
import 'package:maresto/presentation/screen/home_screen.dart';
import 'package:maresto/presentation/screen/profile_setting_screen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<IndexNavProvider>(
        builder: (context, value, child) {
          return Builder(
            builder: (context) {
              switch (value.indexBottomNavBar) {
                case 2:
                  return const ProfileSettingsScreen();
                case 1:
                  return const FavoriteScreen();
                default:
                  return const HomeScreen();
              }
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: context.watch<IndexNavProvider>().indexBottomNavBar,
        onTap: (index) {
          context.read<IndexNavProvider>().setIndextBottomNavBar = index;
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            tooltip: "Home",
            key: ValueKey("bottomNavHome"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorite",
            tooltip: "Favorite",
            key: ValueKey("bottomNavFavorite"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Setting",
            tooltip: "Setting",
            key: ValueKey("bottomNavProfile"),
          ),
        ],
      ),
    );
  }
}
