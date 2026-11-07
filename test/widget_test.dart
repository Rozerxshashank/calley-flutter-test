import 'package:flutter_test/flutter_test.dart';
import 'package:calley_app/core/constants/app_strings.dart';
import 'package:calley_app/main.dart';

void main() {
  testWidgets('CalleyApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CalleyApp());
    expect(find.byType(CalleyApp), findsOneWidget);
  });

  test('Multi-language translation tests for Hindi and all languages', () {
    // English test
    AppStrings.setLanguage('en');
    expect(AppStrings.dashboard, 'Dashboard');
    expect(AppStrings.pending, 'Pending');
    expect(AppStrings.done, 'Done');
    expect(AppStrings.schedule, 'Schedule');
    expect(AppStrings.calls, 'Calls');
    expect(AppStrings.startCallingNow, 'Start Calling Now');

    // Hindi test
    AppStrings.setLanguage('hi');
    expect(AppStrings.dashboard, 'डैशबोर्ड');
    expect(AppStrings.pending, 'लंबित');
    expect(AppStrings.done, 'पूर्ण');
    expect(AppStrings.schedule, 'शेड्यूल');
    expect(AppStrings.calls, 'कॉल्स');
    expect(AppStrings.callsUpper, 'कॉल्स');
    expect(AppStrings.startCallingNow, 'अभी कॉल करना शुरू करें');
    expect(AppStrings.callRecords, 'कॉल रिकॉर्ड्स');
    expect(AppStrings.clearFilter, 'फ़िल्टर हटाएं');

    // Bengali test
    AppStrings.setLanguage('bn');
    expect(AppStrings.dashboard, 'ড্যাশবোর্ড');
    expect(AppStrings.calls, 'কল');

    // Spanish test
    AppStrings.setLanguage('es');
    expect(AppStrings.dashboard, 'Panel de control');
    expect(AppStrings.calls, 'Llamadas');

    // French test
    AppStrings.setLanguage('fr');
    expect(AppStrings.dashboard, 'Tableau de bord');
    expect(AppStrings.calls, 'Appels');

    // Reset back to English
    AppStrings.setLanguage('en');
  });
}
