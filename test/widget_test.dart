import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_campus_app/main.dart';
import 'package:smart_campus_app/services/sync_service.dart';

class MockSyncService extends Mock implements SyncService {}

void main() {
  late MockSyncService mockSyncService;

  setUp(() async {
    mockSyncService = MockSyncService();
    // Setup any mock behaviors if needed
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(SmartCampusApp(syncService: mockSyncService));

    // Verify that our app starts with the dashboard
    expect(find.text('Smart Campus Insights'), findsOneWidget);
    expect(find.text('Quick Stats'), findsOneWidget);
  });
}