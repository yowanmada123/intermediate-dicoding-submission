import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maresto/core/constants/app_constant.dart';
import 'package:maresto/data/models/customer_review.dart';
import 'package:maresto/data/models/restaurant_detail_response.dart';
import 'package:maresto/data/models/restaurant_list_response.dart';

class RestaurantRemoteDataSource {
  Future<Restaurant> fetchRestaurantList() async {
    final response = await http.get(Uri.parse('$baseUrl/list'));
    if (response.statusCode == 200) {
      return Restaurant.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }

  Future<Restaurant> fetchRestaurants(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search?q=$query'));
    if (response.statusCode == 200) {
      return Restaurant.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to search restaurants');
    }
  }

  Future<RestaurantDetail> fetchRestaurantDetail(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/detail/$id'));
    if (response.statusCode == 200) {
      return RestaurantDetail.fromJson(
          json.decode(response.body)['restaurant']);
    } else {
      throw Exception('Failed to load restaurant details');
    }
  }

  Future<List<CustomerReview>> addReview({
    required String id,
    required String name,
    required String review,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/review'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': id,
        'name': name,
        'review': review,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List reviews = json.decode(response.body)['customerReviews'];
      return reviews.map((json) => CustomerReview.fromJson(json)).toList();
    } else {
      throw Exception('Failed to add review');
    }
  }
}
