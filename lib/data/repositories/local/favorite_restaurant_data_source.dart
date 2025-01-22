import 'package:maresto/data/dataresources/local/sqflite_service.dart';
import 'package:maresto/data/models/restaurant_list_response.dart';

class FavoriteRepository {
  final SqliteService _dbHelper;

  FavoriteRepository(this._dbHelper);

  Future<List<RestaurantInfo>> getFavoriteRestaurants() async {
    return await _dbHelper.getAllItems();
  }

  Future<void> addRestaurantToFavorites(RestaurantInfo restaurant) async {
    await _dbHelper.insertItem(restaurant);
  }

  Future<void> removeRestaurantFromFavorites(String restaurantId) async {
    await _dbHelper.removeItem(restaurantId);
  }
}
