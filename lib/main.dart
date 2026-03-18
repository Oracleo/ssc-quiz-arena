import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'firebase_options.dart';
import 'core/router.dart';
import 'core/theme.dart';
import 'providers/app_provider.dart';
import 'providers/quiz_provider.dart';
import 'screens/no_internet_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait on mobile only (not web or desktop)
  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (!e.toString().contains('duplicate-app')) {
      rethrow;
    }
  }

  runApp(const SSCQuizArena());
}

class SSCQuizArena extends StatelessWidget {
  const SSCQuizArena({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()..init()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
      ],
      child: Consumer<AppProvider>(
        builder: (context, app, _) {
          return MaterialApp.router(
            title: 'SSC Quiz Arena',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: app.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            routerConfig: appRouter,
            builder: (context, child) {
              return _ConnectivityGate(child: child!);
            },
          );
        },
      ),
    );
  }
}

class _ConnectivityGate extends StatefulWidget {
  const _ConnectivityGate({required this.child});

  final Widget child;

  @override
  State<_ConnectivityGate> createState() => _ConnectivityGateState();
}

class _ConnectivityGateState extends State<_ConnectivityGate> {
  bool _isOnline = true;
  bool _checking = true;
  late final StreamSubscription<List<ConnectivityResult>> _sub;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _sub = Connectivity().onConnectivityChanged.listen(_handleChange);
  }

  Future<void> _checkConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    _handleChange(results);
  }

  void _handleChange(List<ConnectivityResult> results) {
    final online = results.any((r) => r != ConnectivityResult.none);
    if (mounted) {
      setState(() {
        _isOnline = online;
        _checking = false;
      });
    }
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return Scaffold(
        backgroundColor: context.bgColor,
        body: Center(
          child: CircularProgressIndicator(color: context.goldColor),
        ),
      );
    }

    if (!_isOnline) {
      return NoInternetScreen(onRetry: _checkConnectivity);
    }

    return widget.child;
  }
}
