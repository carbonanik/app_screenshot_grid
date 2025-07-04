import 'features/banner_generator/presentation/pages/banner_generator_page.dart';
import 'core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/models/project.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ProjectAdapter());
  Hive.registerAdapter(BackgroundTypeHiveAdapter());
  await Hive.openBox<Project>('project_box');
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
