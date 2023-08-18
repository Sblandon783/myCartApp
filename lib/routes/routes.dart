import 'package:flutter/material.dart';
import 'package:soccer/pages/login/login_page.dart';

import '../pages/home/home_page.dart';
import '../tabs_page.dart';

Map<String, WidgetBuilder> getAplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => const TabsPage(),
    '/home': (BuildContext context) => const HomePage(),
    '/now': (BuildContext context) => const TabsPage(),
    '/login': (BuildContext context) => const LoginPage(),
  };
}
