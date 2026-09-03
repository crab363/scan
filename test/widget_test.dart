import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/services/audio_service.dart';

void main() {
  testWidgets('ScanverseApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ScanverseApp());

    // Verify that SCANVERSE header is present
    expect(find.text('SCANVERSE'), findsWidgets);

    // Stop background timers for test cleanup
    SoundService().stop();
  });
}
