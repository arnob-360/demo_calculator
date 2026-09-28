import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/constant/app_values.dart';
import '../core/di/injection_container.dart';
import '../features/calculator/presentation/bloc/calculator_bloc.dart';
import '../features/calculator/presentation/pages/calculator_page.dart';
import 'app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => getIt<CalculatorBloc>())],
      child: MaterialApp(
        title: AppValues.appName,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const CalculatorPage(),
      ),
    );
  }
}
