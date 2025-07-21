import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/transaction_provider.dart';
import 'screens/login.dart';
import 'screens/dashboard.dart';
import 'screens/register.dart';

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
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
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
            home: FutureBuilder(
              future: authProvider.tryAutoLogin(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  if (authProvider.isAuthenticated) {
                    return DashboardScreen();
                  } else {
                    return LoginScreen();
                  }
                }
              },
            ),
            routes: {
              '/login': (_) => LoginScreen(),
              '/register': (_) => RegisterScreen(),
              '/dashboard': (_) => DashboardScreen(),
            },
          );
        },
      ),
    );
  }
}
