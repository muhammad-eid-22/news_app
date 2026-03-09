import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'core/config/bloc_observer.dart';
import 'core/routes/app_router.dart';
import 'core/routes/page_route_name.dart';
import 'core/theme/theme_manager.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: PageRouteName.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
