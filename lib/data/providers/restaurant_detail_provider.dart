import 'package:flutter/material.dart';
import 'package:maresto/data/repositories/remote/restaurant_repository.dart';
import 'package:maresto/data/state/restaurant_add_review_state.dart';
import '../state/restaurant_detail_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final RestaurantRepository repository;

  RestaurantDetailProvider({required this.repository});

  RestaurantDetailState _detailState = DetailLoading();
  RestaurantDetailState get detailState => _detailState;

  AddReviewState _addReviewState = AddReviewIdle();
  AddReviewState get addReviewState => _addReviewState;

  bool isDescriptionExpanded = false;

  int currentPage = 0;
  final int reviewsPerPage = 4;

  void toggleDescription() {
    isDescriptionExpanded = !isDescriptionExpanded;
    notifyListeners();
  }

  void nextPage() {
    currentPage++;
    notifyListeners();
  }

  void previousPage() {
    currentPage--;
    notifyListeners();
  }

  Future<void> fetchRestaurantDetail(String id) async {
    _detailState = DetailLoading();
    notifyListeners();

    try {
      final restaurantDetail = await repository.fetchRestaurantDetail(id);
      _detailState = DetailSuccess(restaurantDetail);
    } catch (e) {
      _detailState = DetailError(e.toString());
    }
    notifyListeners();
  }

  Future<void> addReview(String id, String name, String review) async {
    _addReviewState = AddReviewSubmitting();
    notifyListeners();

    try {
      await repository.addReview(id: id, name: name, review: review);
      _addReviewState = AddReviewSuccess();

      await fetchRestaurantDetail(id);
    } catch (e) {
      _addReviewState = AddReviewError(e.toString());
    }
    notifyListeners();
  }
}
