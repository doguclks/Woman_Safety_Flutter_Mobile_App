import 'package:app/pages/emergency_contact_page.dart';
import 'package:app/pages/guide_page.dart';
import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'themes/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yalnız Değilsin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.backgroundColor,
          titleTextStyle: TextStyle(color: AppColors.textColor),
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
