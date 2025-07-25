import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/transaction_provider.dart';
import 'providers/job_provider.dart';

import 'screens/login.dart';
import 'screens/dashboard.dart';
import 'screens/register.dart';
import 'screens/postjob.dart';
import 'screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _appTitle = 'Personal Finance Tracker';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => JobProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: _appTitle,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        home: AuthWrapper(),
        routes: {
          '/login': (_) => LoginScreen(),
          '/register': (_) => RegisterScreen(),
          '/dashboard': (_) => DashboardScreen(),
          '/postjob': (_) => PostJobScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.isAuthenticated) {
      return HomePage();
    } else {
      return LoginScreen();
    }
  }
}
