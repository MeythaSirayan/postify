import 'package:flutter_test/flutter_test.dart';
import 'package:postify/main.dart';

void main() {
  testWidgets('POSTIFY app smoke test', (tester) async {
    await tester.pumpWidget(const PostifyApp());

    expect(find.text('POSTIFY'), findsOneWidget);
  });
}
