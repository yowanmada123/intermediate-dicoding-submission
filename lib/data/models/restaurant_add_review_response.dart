import 'dart:convert';

import 'package:maresto/data/models/customer_review.dart';

RestaurantAddReview restaurantAddReviewFromJson(String str) =>
    RestaurantAddReview.fromJson(json.decode(str));

String restaurantAddReviewToJson(RestaurantAddReview data) =>
    json.encode(data.toJson());

class RestaurantAddReview {
  bool error;
  String message;
  List<CustomerReview> customerReviews;

  RestaurantAddReview({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  factory RestaurantAddReview.fromJson(Map<String, dynamic> json) =>
      RestaurantAddReview(
        error: json["error"] ?? false,
        message: json["message"] ?? "",
        customerReviews: json["customerReviews"] != null
            ? List<CustomerReview>.from(
                json["customerReviews"].map((x) => CustomerReview.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "customerReviews":
            List<dynamic>.from(customerReviews.map((x) => x.toJson())),
      };
}
