import 'package:app/pages/emergency_contact_page.dart';
import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'colors/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.backgroundColor,
        ),
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        scaffoldBackgroundColor: AppColors.backgroundColor,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
