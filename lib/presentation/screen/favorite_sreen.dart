import 'package:flutter/material.dart';
import 'package:maresto/core/constants/navigation_route.dart';
import 'package:maresto/data/providers/restaurant_favorite_provider.dart';
import 'package:maresto/data/state/restaurant_favorite_state.dart';
import 'package:maresto/presentation/widgets/loading_widget.dart';
import 'package:maresto/presentation/widgets/restaurant_card_widget.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<FavoriteRestaurantProvider>(context, listen: false)
          .loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Restaurants'),
      ),
      body: Consumer<FavoriteRestaurantProvider>(
        builder: (context, favoriteProvider, child) {
          final state = favoriteProvider.state;

          if (state is FavoriteRestaurantLoading) {
            return const Center(child: LoadingWidget());
          }

          if (state is FavoriteRestaurantError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: favoriteProvider.loadFavorites,
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          if (state is FavoriteRestaurantIdle ||
              state is FavoriteRestaurantSuccess) {
            final restaurants =
                state is FavoriteRestaurantSuccess ? state.restaurants : [];

            if (restaurants.isEmpty) {
              return const Center(child: Text('No favorite restaurants.'));
            }

            return ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return RestaurantCard(
                  restaurant: restaurant,
                  key: const ValueKey("actionToDetail"),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      NavigationRoute.detailRoute.name,
                      arguments: restaurant.id,
                    );
                  },
                  isFavoriteCard: true,
                  onDelete: () async {
                    await favoriteProvider.removeFromFavorites(restaurant.id);
                    await favoriteProvider.loadFavorites();
                  },
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
