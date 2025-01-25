import 'package:flutter_test/flutter_test.dart';
import 'package:maresto/data/models/restaurant_list_response.dart';
import 'package:maresto/data/providers/restaurant_favorite_provider.dart';
import 'package:maresto/data/repositories/local/favorite_restaurant_data_source.dart';
import 'package:maresto/data/state/restaurant_favorite_state.dart';
import 'package:mocktail/mocktail.dart';

// Mock untuk FavoriteRepository
class MockFavoriteRepository extends Mock implements FavoriteRepository {}

void main() {
  late FavoriteRestaurantProvider favoriteProvider;
  late MockFavoriteRepository mockRepository;

  setUp(() {
    mockRepository = MockFavoriteRepository();
    favoriteProvider = FavoriteRestaurantProvider(mockRepository);
  });

  group('FavoriteRestaurantProvider - loadFavorites', () {
    test('should fetch all favorite restaurants successfully', () async {
      final mockRestaurants = [
        RestaurantInfo(
          id: '1',
          name: 'Mock Restaurant 1',
          description: 'A great mock restaurant',
          pictureId: 'image_1',
          city: 'Mock City',
          rating: 4.5,
        ),
        RestaurantInfo(
          id: '2',
          name: 'Mock Restaurant 2',
          description: 'Another great mock restaurant',
          pictureId: 'image_2',
          city: 'Mock City 2',
          rating: 4.0,
        ),
      ];

      when(() => mockRepository.getFavoriteRestaurants())
          .thenAnswer((_) async => mockRestaurants);

      await favoriteProvider.loadFavorites();

      verify(() => mockRepository.getFavoriteRestaurants()).called(1);
      expect(favoriteProvider.state, isA<FavoriteRestaurantSuccess>());
      final state = favoriteProvider.state as FavoriteRestaurantSuccess;
      expect(state.restaurants.length, 2);
      expect(state.restaurants[0].name, 'Mock Restaurant 1');
    });

    test('should handle errors when fetching favorite restaurants', () async {
      when(() => mockRepository.getFavoriteRestaurants())
          .thenThrow(Exception('Failed to fetch favorites'));

      await favoriteProvider.loadFavorites();

      verify(() => mockRepository.getFavoriteRestaurants()).called(1);
      expect(favoriteProvider.state, isA<FavoriteRestaurantError>());
      final state = favoriteProvider.state as FavoriteRestaurantError;
      expect(state.errorMessage, 'Exception: Failed to fetch favorites');
    });
  });
}
