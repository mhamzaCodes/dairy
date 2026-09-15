// Basic Flutter widget test for Dairy Khata App

import 'package:dairy_farm/core/constants/app_strings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('App title verification test', () {
    expect(AppStrings.appName, 'Dairy Khata');
  });
}
