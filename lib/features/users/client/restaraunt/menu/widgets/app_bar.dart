import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '/core/router/router.dart';

PreferredSizeWidget buildNarrowAppBar(BuildContext context) {
  final theme = Theme.of(context);
  
  return AppBar(
    automaticallyImplyLeading: true,
    titleSpacing: 0,
    leading: SizedBox(
      width: 80,
      child: SizedBox(
        height: 40,
        width: 40,
        child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
      ),
    ),
    title: Text('Меню', style: theme.textTheme.titleMedium),
    actions: [
      IconButton(
        icon: const Icon(Icons.person),
        onPressed: () {
          context.router.push(const ProfileRoute());
        },
        tooltip: 'Профиль',
      ),
      Flexible(
        child: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
          },
          iconSize: 40,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
        ),
      ),
    ],
  );
}

PreferredSizeWidget buildWideAppBar(BuildContext context) {
  final theme = Theme.of(context);
  
  return AppBar(
    automaticallyImplyLeading: false,
    centerTitle: false,
    titleSpacing: 16,
    leading: SizedBox(
      height: 40,
      width: 40,
      child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
    ),
    title: TextButton.icon(
      icon: const Icon(Icons.location_city, color: Colors.green),
      label: Text('Таганрог', style: theme.textTheme.labelMedium),
      onPressed: () {
      },
    ),
    actions: [
      TextButton(
        onPressed: () {}, 
        child: Text('Акции', style: theme.textTheme.titleSmall),
      ),
      TextButton(
        onPressed: () {}, 
        child: Text('Доставка и оплата', style: theme.textTheme.titleSmall),
      ),
      TextButton(
        onPressed: () {}, 
        child: Text('Роллы Доставка еды', style: theme.textTheme.titleSmall),
      ),
      const SizedBox(width: 20),
      TextButton(
        onPressed: () {},
        child: Text(
          '+79897035866',
          style: theme.textTheme.titleLarge,
        ),
      ),
      IconButton(
        icon: const Icon(Icons.person),
        onPressed: () {
          context.router.push(const ProfileRoute());
        },
        tooltip: 'Профиль',
      ),
      const SizedBox(width: 16),
    ],
  );
}
