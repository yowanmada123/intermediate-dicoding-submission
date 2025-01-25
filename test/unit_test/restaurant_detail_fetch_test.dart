import 'package:flutter_test/flutter_test.dart';
import 'package:maresto/data/models/customer_review.dart';
import 'package:maresto/data/models/restaurant_detail_response.dart';
import 'package:maresto/data/providers/restaurant_detail_provider.dart';
import 'package:maresto/data/repositories/remote/restaurant_repository.dart';
import 'package:maresto/data/state/restaurant_detail_state.dart';
import 'package:mocktail/mocktail.dart';

class MockRestaurantRepository extends Mock implements RestaurantRepository {}

void main() {
  late RestaurantDetailProvider provider;
  late MockRestaurantRepository mockRepository;

  setUp(() {
    mockRepository = MockRestaurantRepository();
    provider = RestaurantDetailProvider(repository: mockRepository);
  });

  group('RestaurantDetailProvider - fetchRestaurantDetail', () {
    test('should fetch restaurant detail successfully', () async {
      final mockRestaurantDetail = RestaurantDetail(
        id: "zvf11c0sukfw1e867",
        name: "Gigitan Cepat",
        description:
            "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue.",
        city: "Bali",
        address: "Jln. Belimbing Timur no 27",
        pictureId: "38",
        categories: [
          Category(name: "Italia"),
          Category(name: "Sop"),
        ],
        menus: Menus(
          foods: [
            Category(name: "Tumis leek"),
            Category(name: "Paket rosemary"),
          ],
          drinks: [
            Category(name: "Jus apel"),
            Category(name: "Air"),
          ],
        ),
        rating: 4.0,
        customerReviews: [
          CustomerReview(
              name: "Arif",
              review: "Saya sangat suka menu malamnya!",
              date: "13 November 2019"),
          CustomerReview(
              name: "Gilang",
              review: "Harganya murah sekali!",
              date: "13 Juli 2019"),
        ],
      );

      when(() => mockRepository.fetchRestaurantDetail("zvf11c0sukfw1e867"))
          .thenAnswer((_) async => mockRestaurantDetail);

      await provider.fetchRestaurantDetail("zvf11c0sukfw1e867");

      expect(provider.detailState, isA<DetailSuccess>());
      final successState = provider.detailState as DetailSuccess;
      expect(successState.restaurantDetail.id, "zvf11c0sukfw1e867");
      expect(successState.restaurantDetail.name, "Gigitan Cepat");
      expect(successState.restaurantDetail.city, "Bali");
    });

    test('should handle error when fetching restaurant list fails', () async {
      when(() => mockRepository.fetchRestaurantDetail("zvf11c0sukfw1e867"))
          .thenThrow(Exception('Failed to load restaurant details'));

      await provider.fetchRestaurantDetail("zvf11c0sukfw1e867");

      expect(provider.detailState, isA<DetailError>());
      final errorState = provider.detailState as DetailError;
      expect(errorState.errorMessage,
          'Exception: Failed to load restaurant details');
    });
  });
}
