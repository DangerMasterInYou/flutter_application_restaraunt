import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/core/router/router.dart';

PreferredSizeWidget buildNarrowAppBar(BuildContext context) {
  final theme = Theme.of(context);
  
  return AppBar(
    automaticallyImplyLeading: true,
    titleSpacing: 0,
    leading: SizedBox(
      width: 80,
      child: SizedBox(
        height: 60,
        width: 60,
        child: SvgPicture.asset('assets/svg/logo.svg', fit: BoxFit.contain,),
      ),
    ),
    title: Text('Меню', style: theme.textTheme.titleMedium),
    actions: [
      IconButton(
        icon: const Icon(Icons.person),
        onPressed: () {
          context.router.push(const OrdersRoute());
        },
        tooltip: 'Заказы',
        hoverColor: Colors.white,
      ),
      IconButton(
        icon: const Icon(Icons.person),
        onPressed: () {
          context.router.push(const ProfileRoute());
        },
        tooltip: 'Профиль',
        hoverColor: Colors.white,
      ),
      Flexible(
        child: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
          },
          iconSize: 40,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          hoverColor: Colors.white,
        highlightColor: Colors.white,
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
      height: 60,
      width: 60,
      child: SvgPicture.asset('assets/svg/logo.svg', fit: BoxFit.contain),
    ),
    title: TextButton.icon(
      icon: Icon(Icons.location_city, color: theme.iconTheme.color, size: 30),
      label: Text('Ханты-Мансийск, Калинина, 22', style: theme.textTheme.labelMedium),
      onPressed: null,
    ),
    actions: [
      TextButton(
        onPressed: () {}, 
        child: Text('Акции', style: theme.textTheme.titleLarge),
      ),
      const SizedBox(width: 20),
      TextButton(
        onPressed: () {},
        child: Text(
          '+7 (900) 390-72-05',
          style: theme.textTheme.titleLarge,
        ),
      ),
      IconButton(
        icon: const Icon(Icons.list),
        onPressed: () {
          context.router.push(const OrdersRoute());
        },
        tooltip: 'Заказы',
        hoverColor: Colors.white,
      ),
      IconButton(
        icon: const Icon(Icons.person),
        onPressed: () {
          context.router.push(const ProfileRoute());
        },
        tooltip: 'Профиль',
        hoverColor: Colors.white,
        highlightColor: Colors.white,
      ),
      const SizedBox(width: 16),
    ],
  );
}
