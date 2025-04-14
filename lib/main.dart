import 'package:flutter/cupertino.dart';
import 'package:btzs_sandbox/pages/exposure_list_page.dart';
import 'package:btzs_sandbox/pages/exposure_flow_page.dart';
import 'package:btzs_sandbox/utils/session.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: Brightness.dark,
      ),
      home: ExposureListPage(),
    );
  }
}
