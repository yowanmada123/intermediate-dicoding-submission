import 'package:maresto/data/dataresources/remote/restaurant_remote_data_source.dart';
import 'package:maresto/data/models/customer_review.dart';
import 'package:maresto/data/models/restaurant_detail_response.dart';
import 'package:maresto/data/models/restaurant_list_response.dart';

class RestaurantRepository {
  final RestaurantRemoteDataSource remoteDataSource;

  RestaurantRepository({required this.remoteDataSource});

  Future<Restaurant> fetchRestaurantList() async {
    return await remoteDataSource.fetchRestaurantList();
  }

  Future<Restaurant> fetchRestaurants(String query) async {
    return await remoteDataSource.fetchRestaurants(query);
  }

  Future<RestaurantDetail> fetchRestaurantDetail(String id) async {
    return await remoteDataSource.fetchRestaurantDetail(id);
  }

  Future<List<CustomerReview>> addReview({
    required String id,
    required String name,
    required String review,
  }) async {
    return await remoteDataSource.addReview(id: id, name: name, review: review);
  }
}
