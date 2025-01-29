import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:maresto/restaurant_app.dart';
import 'evaluate_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("integrate all feature", (tester) async {
    final evaluateRobot = EvaluateRobot(tester);

    await evaluateRobot.loadUI(RestaurantApp());
    await evaluateRobot.goToPageWithTab("bottomNavHome");
    await evaluateRobot.typeFormula("Ampiran");
    await evaluateRobot.typeFormula("");

    await evaluateRobot.actionButton("actionToDetail");
    await evaluateRobot.actionAddFavorite();
    await evaluateRobot.actionBackToListRestaurant();
    await evaluateRobot.actionButton("actionToDetail", index: 1);
    await evaluateRobot.actionAddFavorite();
    await evaluateRobot.actionBackToListRestaurant();

    await evaluateRobot.goToPageWithTab("bottomNavFavorite");
    await evaluateRobot.actionButton("actionToDetail");
    await evaluateRobot.actionBackToListRestaurant();
    await evaluateRobot.goToPageWithTab("bottomNavProfile");
    await evaluateRobot.actionButton("themeToggleTile");
    await evaluateRobot.actionButton("themeToggleTile");
    await evaluateRobot.actionButton("alarmToggleTile");
    await evaluateRobot.actionButton("alarmToggleTile");
  });
}
