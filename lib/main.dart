import 'package:flutter/material.dart';
import 'package:soccer/routes/routes.dart';
import 'package:soccer/user_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/home/home_page.dart';
import 'services/notifi_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz2;

//PW MyCartAppSuperSegura
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /*
  NotificationService().initNotification();
  tz.initializeTimeZones();
  tz2.setLocalLocation(tz2.getLocation('America/Costa_Rica'));
  */
  await Supabase.initialize(
    url: 'https://jocfuedqiwravursmelo.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpvY2Z1ZWRxaXdyYXZ1cnNtZWxvIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTIyMDQ0MjcsImV4cCI6MjAwNzc4MDQyN30.Flv1XduQ8m0b7VGDBjG5bSQ-9Q1-zblUNfQVXqlMzkM',
  );
  final prefs = UserPreferences();
  await prefs.initPrefs();

  return runApp(MyApp());
}

// ignore: use_key_in_widget_constructors, must_be_immutable
class MyApp extends StatelessWidget {
  bool isLogin = false;
  String initialRoute = "/tab";
  final UserPreferences _prefs = UserPreferences();

  @override
  Widget build(BuildContext context) {
    if (!_prefs.isLogin) {
      initialRoute = "/login";
    }

    return MaterialApp(
      title: 'Componets App',
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: getAplicationRoutes(),
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (context) => const HomePage());
      },
    );
  }
}
