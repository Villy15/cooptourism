// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cooptourism/data/models/cooperatives.dart';
import 'package:cooptourism/data/repositories/cooperative_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  group('CooperativesRepository', () {
    late CooperativesRepository repository;

    setUp(() {
      repository = CooperativesRepository();
    });

    test('addCooperative adds a cooperative to Firestore', () async {
      // Create a new cooperative
      final cooperative = CooperativesModel(
        name: 'Test Cooperative',
        city: 'Test City',
        province: 'Test Province',
      );

      // Add the cooperative to Firestore
      await repository.addCooperative(cooperative);

      // Get the added cooperative from Firestore
      // final addedCooperative = await repository.getCooperative(cooperative.id);

      // Check that the added cooperative matches the original cooperative
      // expect(addedCooperative, cooperative);
    });
  });
}