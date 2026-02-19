import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/global_theme_provider.dart';
import 'presentation/dashboard/dashboard_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GlobalThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<GlobalThemeProvider>(context);
    
    return MaterialApp(
      title: 'Automation FullStack',
      theme: themeProvider.themeData,
      home: const DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
