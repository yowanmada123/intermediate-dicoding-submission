import 'package:flutter/material.dart';
import 'package:maresto/data/repositories/remote/restaurant_repository.dart';
import '../state/restaurant_state.dart';

class RestaurantProvider extends ChangeNotifier {
  final RestaurantRepository repository;

  RestaurantProvider({required this.repository});

  RestaurantState _state = RestaurantLoading();
  RestaurantState get state => _state;

  Future<void> fetchRestaurantList() async {
    _state = RestaurantLoading();
    notifyListeners();

    try {
      final response = await repository.fetchRestaurantList();
      if (response.restaurants.isEmpty) {
        _state = RestaurantEmpty();
      } else {
        _state = TourismListLoadedState(response.restaurants);
      }
    } catch (e) {
      _state = RestaurantError(e.toString());
    }
    notifyListeners();
  }

  Future<void> searchRestaurants(String query) async {
    _state = RestaurantLoading();
    notifyListeners();

    try {
      final response = await repository.fetchRestaurants(query);
      if (response.restaurants.isEmpty) {
        _state = RestaurantEmpty();
      } else {
        _state = TourismListLoadedState(response.restaurants);
      }
    } catch (e) {
      _state = RestaurantError(e.toString());
    }
    notifyListeners();
  }
}
