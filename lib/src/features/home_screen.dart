import 'package:flutter/material.dart';
import 'package:zeus_app/src/features/pets/pets_screen.dart';
import 'package:zeus_app/src/features/product/product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPage = 0;

  final PageController pageController = PageController();

  void changeCurrentPage(int newValue) {
    currentPage = newValue;
    pageController.jumpToPage(currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: (page) => setState(() {
          currentPage = page;
        }),
        controller: pageController,
        children: const [
          ProductScreen(),
          PetsScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPage,
        height: 60,
        onDestinationSelected: (index) => setState(() {
          changeCurrentPage(index);
        }),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.pets_rounded), label: 'Produtos'),
          NavigationDestination(
              icon: Icon(Icons.schedule_rounded), label: 'Alarmes'),
        ],
      ),
    );
  }
}
