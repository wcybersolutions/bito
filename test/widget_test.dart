import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bito/app/app.dart';

void main() {
  testWidgets('Bito app launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: BitoApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Joseph'), findsOneWidget);
    expect(find.text("Today's Progress"), findsOneWidget);
  });
}

