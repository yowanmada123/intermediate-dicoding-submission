import 'package:flutter/material.dart';
import 'package:maresto/data/models/restaurant_list_response.dart';
import 'package:maresto/data/repositories/local/favorite_restaurant_data_source.dart';
import 'package:maresto/data/state/restaurant_favorite_state.dart';

class FavoriteRestaurantProvider extends ChangeNotifier {
  FavoriteRestaurantState _state = FavoriteRestaurantIdle();
  FavoriteRestaurantState get state => _state;

  final FavoriteRepository _favoriteRepository;
  List<RestaurantInfo> _favoriteRestaurants = [];
  bool _isLoading = false;

  FavoriteRestaurantProvider(this._favoriteRepository);

  List<RestaurantInfo> get favoriteRestaurants => _favoriteRestaurants;
  bool get isLoading => _isLoading;

  Future<void> loadFavorites() async {
    _state = FavoriteRestaurantLoading();
    notifyListeners();

    try {
      _favoriteRestaurants = await _favoriteRepository.getFavoriteRestaurants();
      _state = FavoriteRestaurantSuccess(_favoriteRestaurants);
    } catch (e) {
      _state = FavoriteRestaurantError(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> addToFavorites(RestaurantInfo restaurant) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _favoriteRepository.addRestaurantToFavorites(restaurant);
    } catch (e) {
      debugPrint("Error adding to favorites: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeFromFavorites(String restaurantId) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _favoriteRepository.removeRestaurantFromFavorites(restaurantId);
    } catch (e) {
      debugPrint("Error removing from favorites: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
