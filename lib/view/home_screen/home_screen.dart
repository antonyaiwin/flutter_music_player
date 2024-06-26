import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/home_screen_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: context.read<HomeScreenController>().pageController,
        children: context.read<HomeScreenController>().pageList,
      ),
    );
  }
}
