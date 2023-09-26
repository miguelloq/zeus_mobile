import 'package:flutter/material.dart';
import 'package:zeus_app/src/core/models/theme_model.dart';

import '../../../core/utils/app_constants.dart';

class CustomSliverAppbar extends StatelessWidget {
  final ThemeModel themeModel;
  const CustomSliverAppbar({super.key, required this.themeModel});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          'Gerencimamento de produtos',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        background: Image.asset(
          ImageConstants.imageMenuBackground,
          opacity: themeModel.mode == ThemeMode.light
              ? const AlwaysStoppedAnimation(.75)
              : const AlwaysStoppedAnimation(.1),
          fit: BoxFit.cover,
        ),
      ),
      expandedHeight: 125,
      actions: [
        IconButton(
          onPressed: () => themeModel.toggleMode(),
          icon: const Icon(Icons.wb_sunny_rounded),
        ),
      ],
    );
  }
}
