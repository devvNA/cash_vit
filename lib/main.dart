import 'package:cash_vit/screens/splash_screen/splash_screen.dart';
import 'package:cash_vit/utils/services/local_storage_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'utils/themes/index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService().init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cash Vit',
      theme: AppTheme.theme,
      home: const SplashScreen(),
    );
  }
}
