import 'package:flutter_test/flutter_test.dart';
import 'package:maresto/data/providers/restaurant_provider.dart';
import 'package:maresto/data/state/restaurant_state.dart';
import 'package:maresto/presentation/screen/home_screen.dart';
import 'package:maresto/presentation/widgets/loading_widget.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MockRestaurantProvider extends Mock implements RestaurantProvider {}

void main() {
  late MockRestaurantProvider mockRestaurantProvider;

  setUp(
    () {
      mockRestaurantProvider = MockRestaurantProvider();
    },
  );

  testWidgets(
    'should show loading state when restaurants are being fetched',
    (WidgetTester tester) async {
      when(() => mockRestaurantProvider.state).thenReturn(RestaurantLoading());
      when(() => mockRestaurantProvider.fetchRestaurantList())
          .thenAnswer((_) async => Future.value());

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<RestaurantProvider>(
            create: (_) => mockRestaurantProvider,
            child: const HomeScreen(),
          ),
        ),
      );

      expect(find.byType(LoadingWidget), findsOneWidget);
    },
  );

  testWidgets(
    'should display error message if fetching restaurants fails',
    (WidgetTester tester) async {
      when(() => mockRestaurantProvider.state)
          .thenReturn(RestaurantError('Failed to load restaurants'));
      when(() => mockRestaurantProvider.fetchRestaurantList())
          .thenAnswer((_) async => Future.value());

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<RestaurantProvider>(
            create: (_) => mockRestaurantProvider,
            child: const HomeScreen(),
          ),
        ),
      );

      expect(find.text('Failed to load restaurants'), findsOneWidget);
    },
  );
}
