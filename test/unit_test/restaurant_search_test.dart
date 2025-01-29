import 'package:flutter_test/flutter_test.dart';
import 'package:maresto/data/models/restaurant_list_response.dart';
import 'package:maresto/data/providers/restaurant_provider.dart';
import 'package:maresto/data/repositories/remote/restaurant_repository.dart';
import 'package:maresto/data/state/restaurant_state.dart';
import 'package:mocktail/mocktail.dart';

class MockRestaurantRepository extends Mock implements RestaurantRepository {}

void main() {
  late RestaurantProvider restaurantProvider;
  late MockRestaurantRepository mockRepository;

  setUp(() {
    mockRepository = MockRestaurantRepository();
    restaurantProvider = RestaurantProvider(repository: mockRepository);
  });

  group('RestaurantProvider - searchRestaurants', () {
    test('should search restaurants successfully', () async {
      final mockRestaurants = Restaurant(
        error: false,
        message: 'success',
        count: 1,
        restaurants: [
          RestaurantInfo(
            id: 'rqdv5juczeskfw1e867',
            name: 'Melting Pot',
            description: 'A great place to eat',
            pictureId: '14',
            city: 'Medan',
            rating: 4.2,
          ),
        ],
      );

      when(() => mockRepository.fetchRestaurants('Melting'))
          .thenAnswer((_) async => mockRestaurants);

      await restaurantProvider.searchRestaurants('Melting');

      expect(restaurantProvider.state, isA<TourismListLoadedState>());
      final loadedState = restaurantProvider.state as TourismListLoadedState;
      expect(loadedState.restaurants.length, 1);
      expect(loadedState.restaurants[0].name, 'Melting Pot');
    });

    test('should handle error when searching restaurants fails', () async {
      when(() => mockRepository.fetchRestaurants('Random'))
          .thenThrow(Exception('Failed to search restaurants'));

      await restaurantProvider.searchRestaurants('Random');

      expect(restaurantProvider.state, isA<RestaurantError>());
      final errorState = restaurantProvider.state as RestaurantError;
      expect(
          errorState.errorMessage, 'Exception: Failed to search restaurants');
    });
  });
}
