import 'package:maresto/data/models/restaurant_detail_response.dart';

sealed class RestaurantDetailState {}

class DetailLoading extends RestaurantDetailState {}

class DetailSuccess extends RestaurantDetailState {
  final RestaurantDetail restaurantDetail;

  DetailSuccess(this.restaurantDetail);
}

class DetailError extends RestaurantDetailState {
  final String errorMessage;

  DetailError(this.errorMessage);
}
