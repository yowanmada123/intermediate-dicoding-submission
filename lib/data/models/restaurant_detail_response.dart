import 'dart:convert';

import 'package:maresto/data/models/customer_review.dart';

RestaurantDetailResponse restaurantDetailFromJson(String str) =>
    RestaurantDetailResponse.fromJson(json.decode(str));

String restaurantDetailToJson(RestaurantDetailResponse data) =>
    json.encode(data.toJson());

class RestaurantDetailResponse {
  bool error;
  String message;
  RestaurantDetail restaurant;

  RestaurantDetailResponse({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  factory RestaurantDetailResponse.fromJson(Map<String, dynamic> json) =>
      RestaurantDetailResponse(
        error: json["error"],
        message: json["message"] ?? "",
        restaurant: RestaurantDetail.fromJson(json["restaurant"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "restaurant": restaurant.toJson(),
      };
}

class RestaurantDetail {
  String id;
  String name;
  String description;
  String city;
  String address;
  String pictureId;
  List<Category> categories;
  Menus menus;
  double rating;
  List<CustomerReview> customerReviews;

  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.categories,
    required this.menus,
    required this.rating,
    required this.customerReviews,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) =>
      RestaurantDetail(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        description: json["description"] ?? '',
        city: json["city"] ?? '',
        address: json["address"] ?? '',
        pictureId: json["pictureId"] ?? '',
        categories: json["categories"] != null
            ? List<Category>.from(
                json["categories"].map((x) => Category.fromJson(x)))
            : [],
        menus: json["menus"] != null
            ? Menus.fromJson(json["menus"])
            : Menus(foods: [], drinks: []),
        rating: json["rating"]?.toDouble(),
        customerReviews: json['customerReviews'] != null
            ? List<CustomerReview>.from(
                json['customerReviews'].map((x) => CustomerReview.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "city": city,
        "address": address,
        "pictureId": pictureId,
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "menus": menus.toJson(),
        "rating": rating,
        "customerReviews":
            List<dynamic>.from(customerReviews.map((x) => x.toJson())),
      };

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'city': city,
      'address': address,
      'pictureId': pictureId,
      'rating': rating,
      'categories': categories.isNotEmpty
          ? categories.map((e) => e.toJson()).toList()
          : null,
      'menus': menus.toJson(),
      'customerReviews': customerReviews.isNotEmpty
          ? customerReviews.map((e) => e.toJson()).toList()
          : null,
    };
  }

  factory RestaurantDetail.fromMap(Map<String, dynamic> map) {
    return RestaurantDetail(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      city: map['city'],
      address: map['address'],
      pictureId: map['pictureId'],
      rating: map['rating']?.toDouble(),
      categories: map['categories'] != null
          ? List<Category>.from(
              map['categories'].map((x) => Category.fromJson(x)))
          : [],
      menus: map['menus'] != null
          ? Menus.fromJson(map['menus'])
          : Menus(foods: [], drinks: []),
      customerReviews: map['customerReviews'] != null
          ? List<CustomerReview>.from(
              map['customerReviews'].map((x) => CustomerReview.fromJson(x)))
          : [],
    );
  }
}

class Category {
  String name;

  Category({
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class Menus {
  List<Category> foods;
  List<Category> drinks;

  Menus({
    required this.foods,
    required this.drinks,
  });

  factory Menus.fromJson(Map<String, dynamic> json) => Menus(
        foods:
            List<Category>.from(json["foods"].map((x) => Category.fromJson(x))),
        drinks: List<Category>.from(
            json["drinks"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
        "drinks": List<dynamic>.from(drinks.map((x) => x.toJson())),
      };
}
