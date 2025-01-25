import 'dart:convert';

Restaurant restaurantFromJson(String str) =>
    Restaurant.fromJson(json.decode(str));

String restaurantToJson(Restaurant data) => json.encode(data.toJson());

class Restaurant {
  bool error;
  String message;
  int count;
  int founded;
  List<RestaurantInfo> restaurants;

  Restaurant({
    required this.error,
    required this.message,
    required this.count,
    this.founded = 0,
    required this.restaurants,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        error: json["error"],
        message: json["message"] ?? "",
        count: json["count"] ?? 0,
        founded: json["founded"] ?? 0,
        restaurants: List<RestaurantInfo>.from(
            json["restaurants"].map((x) => RestaurantInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "count": count,
        "founded": founded,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
      };
}

class RestaurantInfo {
  String id;
  String name;
  String description;
  String pictureId;
  String city;
  double rating;

  RestaurantInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory RestaurantInfo.fromJson(Map<String, dynamic> json) => RestaurantInfo(
        id: json["id"] ?? "",
        name: json["name"] ?? "",
        description: json["description"] ?? "",
        pictureId: json["pictureId"] ?? "",
        city: json["city"] ?? "",
        rating: json["rating"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "pictureId": pictureId,
        "city": city,
        "rating": rating,
      };

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'city': city,
      'pictureId': pictureId,
      'rating': rating,
    };
  }

  factory RestaurantInfo.fromMap(Map<String, dynamic> map) {
    return RestaurantInfo(
      id: map['id'] ?? "",
      name: map['name'] ?? "",
      description: map['description'] ?? "",
      city: map['city'] ?? "",
      pictureId: map['pictureId'] ?? "",
      rating: map['rating']?.toDouble(),
    );
  }
}
