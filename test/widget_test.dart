import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:qbittorrent_local_client/core/constants/app_constants.dart';
import 'package:qbittorrent_local_client/main.dart';

void main() {
  tearDown(Get.reset);

  testWidgets('App launches splash screen', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await Get.putAsync<SharedPreferences>(SharedPreferences.getInstance);

    await tester.pumpWidget(const QbittorrentApp());
    await tester.pump();

    expect(find.text(AppConstants.appName), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 500));
  });
}
