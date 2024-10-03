import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:s_chat/screens/auth_screens/auth_gate.dart';

void main() {
  // testWidgets('Material app testing', (WidgetTester widgetTester) async {
  //   await widgetTester.pumpWidget(HomePage());

  //   expect(find.byType(MaterialApp), findsOneWidget);
  // };

  testWidgets('Material app testing', (WidgetTester widgetTester) async {
    await widgetTester.pumpWidget(const GetMaterialApp(
      home: AuthGate(),
    ));

    expect(find.text('abc'), findsOneWidget);
  });

  // group('description', () {
  //   AuthServicesController authServicesControll = AuthServicesController();
  //   setUp(() {
  //     authServicesControll = AuthServicesController();
  //   });

  //   test('descriptionl̥', () async {
  //     //arrange
  //     //acr
  //     final user = await authServicesControll.user;
  //     // accerts
  //     expect(user, isA<MessageModel>());
  //   });
  // });
}
