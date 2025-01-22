import 'package:maresto/data/models/restaurant_list_response.dart';

sealed class RestaurantState {}

class RestaurantLoading extends RestaurantState {}

class TourismListLoadedState extends RestaurantState {
  final List<RestaurantInfo> restaurants;

  TourismListLoadedState(this.restaurants);
}

class RestaurantError extends RestaurantState {
  final String errorMessage;

  RestaurantError(this.errorMessage);
}

class RestaurantEmpty extends RestaurantState {}
