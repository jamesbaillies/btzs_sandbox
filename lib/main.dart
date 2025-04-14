import 'package:flutter/cupertino.dart';
import 'pages/exposure_list_page.dart'; // Only import what you use

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
      home: ExposureListPage(), // This pulls in the rest
    );
  }
}
