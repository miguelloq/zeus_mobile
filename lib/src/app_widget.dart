import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zeus_app/src/core/themes/themes.dart';
import 'package:zeus_app/src/features/product/product_screen.dart';
import 'package:zeus_app/src/features/product/vm/product_vm.dart';
import 'package:zeus_app/src/features/product/services/product_service.dart';
import 'package:zeus_app/src/features/splash_screen.dart';
import 'core/models/theme_model.dart';
import 'core/services/http_service.dart';
import 'features/home_screen.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => HttpService()),
        Provider(
          create: (context) => ProductService(httpService: context.read()),
        ),
        Provider(
          create: (context) => ProductVM(productService: context.read()),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeModel(),
        ),
      ],
      child: Consumer<ThemeModel>(
        builder: (_, themeModel, ___) => MaterialApp(
          title: 'Zeus_App',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeModel.mode,
          routes: {
            '/splash': (_) => const SplashPage(),
            '/home': (_) => const HomeScreen(),
            '/product': (_) => const ProductScreen(),
          },
          initialRoute: '/splash',
        ),
      ),
    );
  }
}
