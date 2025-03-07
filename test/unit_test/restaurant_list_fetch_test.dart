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

  group(
    'RestaurantProvider - fetchRestaurantList',
    () {
      test(
        'should fetch restaurant list successfully',
        () async {
          final mockRestaurants = Restaurant(
            error: false,
            message: 'success',
            count: 2,
            restaurants: [
              RestaurantInfo(
                id: 'rqdv5juczeskfw1e867',
                name: 'Melting Pot',
                description: 'A great place to eat',
                pictureId: '14',
                city: 'Medan',
                rating: 4.2,
              ),
              RestaurantInfo(
                id: 's1knt6za9kkfw1e867',
                name: 'Kafe Kita',
                description: 'Cozy cafe',
                pictureId: '25',
                city: 'Gorontalo',
                rating: 4.0,
              ),
            ],
          );
          when(() => mockRepository.fetchRestaurantList())
              .thenAnswer((_) async => mockRestaurants);

          await restaurantProvider.fetchRestaurantList();

          expect(restaurantProvider.state, isA<TourismListLoadedState>());
          final loadedState =
              restaurantProvider.state as TourismListLoadedState;
          expect(loadedState.restaurants.length, 2);
          expect(loadedState.restaurants[0].name, 'Melting Pot');
        },
      );

      test(
        'should handle error when fetching restaurant list fails',
        () async {
          when(() => mockRepository.fetchRestaurantList())
              .thenThrow(Exception('Failed to load restaurant list'));

          await restaurantProvider.fetchRestaurantList();

          expect(restaurantProvider.state, isA<RestaurantError>());
          final errorState = restaurantProvider.state as RestaurantError;
          expect(errorState.errorMessage,
              'Exception: Failed to load restaurant list');
        },
      );
    },
  );
}
