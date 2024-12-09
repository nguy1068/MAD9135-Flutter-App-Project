//main.dart
//Entry point for movie night app

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers.dart';
import 'screens.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SessionProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        home: WelcomeScreen(),
      ),
    );
  }
}
