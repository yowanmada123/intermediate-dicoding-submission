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

  Future addToFavorites(RestaurantInfo restaurant) async {
    var msg = "";

    try {
      _isLoading = true;
      msg = "success add to favorite";

      notifyListeners();

      await _favoriteRepository.addRestaurantToFavorites(restaurant);
    } catch (e) {
      msg = "Error adding to favorites: $e";
    }
    _isLoading = false;
    notifyListeners();
    return msg;
  }

  Future removeFromFavorites(String restaurantId) async {
    var msg = "";
    try {
      _isLoading = true;
      msg = "success remove from favorite";

      notifyListeners();

      await _favoriteRepository.removeRestaurantFromFavorites(restaurantId);
    } catch (e) {
      msg = "Error removing from favorites: $e";
    }
    _isLoading = false;
    notifyListeners();
    return msg;
  }
}
