import 'package:maresto/data/models/restaurant_list_response.dart';

sealed class FavoriteRestaurantState {}

class FavoriteRestaurantIdle extends FavoriteRestaurantState {}

class FavoriteRestaurantLoading extends FavoriteRestaurantState {}

class FavoriteRestaurantSuccess extends FavoriteRestaurantState {
  final List<RestaurantInfo> restaurants;

  FavoriteRestaurantSuccess(this.restaurants);
}

class FavoriteRestaurantError extends FavoriteRestaurantState {
  final String errorMessage;

  FavoriteRestaurantError(this.errorMessage);
}
