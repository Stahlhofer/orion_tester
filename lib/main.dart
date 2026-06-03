import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'utils/app_theme.dart';
import 'views/routine_list_page.dart';

void main() {
  sqfliteFfiInit();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Orion Tester',
      theme: AppTheme.dark(),
      home: const RoutineListPage(),
    );
  }
}
