import 'package:flutter_test/flutter_test.dart';
import 'package:maresto/data/models/restaurant_list_response.dart';
import 'package:maresto/data/providers/restaurant_provider.dart';
import 'package:maresto/data/repositories/remote/restaurant_repository.dart';
import 'package:maresto/data/state/restaurant_state.dart';
import 'package:mocktail/mocktail.dart';

// Mock class untuk repository
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
      // Arrange: Buat data mock untuk pencarian restoran
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

      // Mock response dari repository
      when(() => mockRepository.fetchRestaurants('Melting'))
          .thenAnswer((_) async => mockRestaurants);

      // Act: Panggil searchRestaurants
      await restaurantProvider.searchRestaurants('Melting');

      // Assert: Periksa apakah state sudah berubah menjadi TourismListLoadedState dengan restoran yang benar
      expect(restaurantProvider.state, isA<TourismListLoadedState>());
      final loadedState = restaurantProvider.state as TourismListLoadedState;
      expect(loadedState.restaurants.length, 1);
      expect(loadedState.restaurants[0].name, 'Melting Pot');
    });

    test('should handle error when searching restaurants fails', () async {
      // Arrange: Mock repository untuk melempar error saat pencarian
      when(() => mockRepository.fetchRestaurants('Random'))
          .thenThrow(Exception('Failed to search restaurants'));

      // Act: Panggil searchRestaurants
      await restaurantProvider.searchRestaurants('Random');

      // Assert: Periksa apakah state berubah menjadi RestaurantError dengan pesan yang benar
      expect(restaurantProvider.state, isA<RestaurantError>());
      final errorState = restaurantProvider.state as RestaurantError;
      expect(errorState.errorMessage, 'Failed to search restaurants');
    });
  });
}
