import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maresto/core/constants/navigation_route.dart';
import 'package:maresto/data/state/restaurant_state.dart';
import 'package:provider/provider.dart';
import 'package:maresto/data/providers/restaurant_provider.dart';
import 'package:maresto/presentation/widgets/loading_widget.dart';
import 'package:maresto/presentation/widgets/restaurant_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<RestaurantProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.fetchRestaurantList();
    });

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    final provider = Provider.of<RestaurantProvider>(context, listen: false);

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isEmpty) {
        provider.fetchRestaurantList();
      } else {
        provider.searchRestaurants(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Text(
                "Find your favorite restaurants easily and quickly!",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search restaurants...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<RestaurantProvider>(
                builder: (context, provider, child) {
                  final state = provider.state;

                  if (state is RestaurantLoading) {
                    return const Center(child: LoadingWidget());
                  }

                  if (state is RestaurantError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(state.errorMessage),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: provider.fetchRestaurantList,
                            child: const Text("Retry"),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is RestaurantEmpty) {
                    return const Center(child: Text("No restaurants found."));
                  }

                  if (state is TourismListLoadedState) {
                    return ListView.builder(
                      itemCount: state.restaurants.length,
                      itemBuilder: (context, index) {
                        final restaurant = state.restaurants[index];
                        return RestaurantCard(
                          restaurant: restaurant,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              NavigationRoute.detailRoute.name,
                              arguments: restaurant.id,
                            );
                          },
                          isFavoriteCard: false,
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
