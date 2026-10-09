import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:lms_app/main.dart';
import 'package:lms_app/providers/app_state_provider.dart';

void main() {
  testWidgets('App loads splash screen test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppStateProvider()),
        ],
        child: const LMSPrepApp(),
      ),
    );
    await tester.pump();
    expect(find.byType(LMSPrepApp), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 4));
  });
}
