import 'features/banner_generator/presentation/pages/banner_generator_page.dart';
import 'core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Banner Generator',
      theme: AppTheme.lightTheme,
      home: const BannerGeneratorPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
