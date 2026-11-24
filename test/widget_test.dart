import 'package:cal_scanner/core/utils/calorie_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CalorieCalculator', () {
    test('maintenance calories for a moderate male', () {
      final kcal = CalorieCalculator.fallbackEstimateCalories(
        weight: 70,
        height: 175,
        age: 30,
        activityLevel: 'Moderate',
        gender: 'Male',
      );
      expect(kcal, 2628);
    });

    test('unknown activity level falls back to sedentary', () {
      final unknown = CalorieCalculator.fallbackEstimateCalories(
        weight: 70, height: 175, age: 30, activityLevel: 'xyz', gender: 'Male',
      );
      final sedentary = CalorieCalculator.fallbackEstimateCalories(
        weight: 70, height: 175, age: 30, activityLevel: 'Sedentary', gender: 'Male',
      );
      expect(unknown, sedentary);
    });

    test('goal adjusts calories', () {
      expect(
        CalorieCalculator.calculateCaloriesBasedOnGoal(
            maintenanceCalories: 2000, goal: 'Weight Loss'),
        1600,
      );
      expect(
        CalorieCalculator.calculateCaloriesBasedOnGoal(
            maintenanceCalories: 2000, goal: 'Muscle Gain'),
        2300,
      );
      expect(
        CalorieCalculator.calculateCaloriesBasedOnGoal(
            maintenanceCalories: 2000, goal: 'Maintain'),
        2000,
      );
    });

    test('macro goals follow the calorie split', () {
      final m = CalorieCalculator.calculateMacroGoals(
          calories: 2000, goal: 'Weight Loss');
      expect(m['proteinGoal'], 150); // 30% / 4
      expect(m['fatGoal'], 56); // 25% / 9
      expect(m['carbsGoal'], 225); // 45% / 4
    });
  });
}
