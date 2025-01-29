import 'package:flutter_test/flutter_test.dart';
import 'package:maresto/data/models/restaurant_list_response.dart';
import 'package:maresto/data/providers/restaurant_favorite_provider.dart';
import 'package:maresto/data/repositories/local/favorite_restaurant_data_source.dart';
import 'package:mocktail/mocktail.dart';

class MockFavoriteRepository extends Mock implements FavoriteRepository {}

void main() {
  late FavoriteRestaurantProvider favoriteProvider;
  late MockFavoriteRepository mockRepository;

  setUp(() {
    mockRepository = MockFavoriteRepository();
    favoriteProvider = FavoriteRestaurantProvider(mockRepository);
  });

  group(
    'FavoriteRestaurantProvider - addToFavorites',
    () {
      test(
        'should add a restaurant to favorites successfully',
        () async {
          final mockRestaurant = RestaurantInfo(
            id: '1',
            name: 'Mock Restaurant',
            description: 'A great mock restaurant',
            pictureId: 'image_1',
            city: 'Mock City',
            rating: 4.5,
          );

          when(() => mockRepository.addRestaurantToFavorites(mockRestaurant))
              .thenAnswer((_) async => Future.value());

          await favoriteProvider.addToFavorites(mockRestaurant);

          verify(() => mockRepository.addRestaurantToFavorites(mockRestaurant))
              .called(1);

          expect(favoriteProvider.isLoading, false);
        },
      );

      test(
        'should handle errors when adding a restaurant to favorites',
        () async {
          final mockRestaurant = RestaurantInfo(
            id: '1',
            name: 'Mock Restaurant',
            description: 'A great mock restaurant',
            pictureId: 'image_1',
            city: 'Mock City',
            rating: 4.5,
          );

          when(() => mockRepository.addRestaurantToFavorites(mockRestaurant))
              .thenThrow(Exception('Failed to add favorite'));

          await favoriteProvider.addToFavorites(mockRestaurant);

          verify(() => mockRepository.addRestaurantToFavorites(mockRestaurant))
              .called(1);

          expect(favoriteProvider.isLoading, false);
        },
      );
    },
  );

  group(
    'FavoriteRestaurantProvider - removeFromFavorites',
    () {
      test(
        'should remove a restaurant from favorites successfully',
        () async {
          const mockRestaurantId = '1';

          when(() => mockRepository.removeRestaurantFromFavorites(
              mockRestaurantId)).thenAnswer((_) async => Future.value());

          await favoriteProvider.removeFromFavorites(mockRestaurantId);

          verify(() => mockRepository
              .removeRestaurantFromFavorites(mockRestaurantId)).called(1);

          expect(favoriteProvider.isLoading, false);
        },
      );

      test(
        'should handle errors when removing a restaurant from favorites',
        () async {
          const mockRestaurantId = '1';

          when(() => mockRepository
                  .removeRestaurantFromFavorites(mockRestaurantId))
              .thenThrow(Exception('Failed to remove favorite'));

          await favoriteProvider.removeFromFavorites(mockRestaurantId);

          verify(() => mockRepository
              .removeRestaurantFromFavorites(mockRestaurantId)).called(1);

          expect(favoriteProvider.isLoading, false);
        },
      );
    },
  );
}
