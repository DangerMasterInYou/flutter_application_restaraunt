import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_restaraunt/core/services/alert_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/core/router/router.dart';

PreferredSizeWidget buildNarrowAppBar(BuildContext context) {
  final theme = Theme.of(context);
  
  return AppBar(
    automaticallyImplyLeading: true,
    titleSpacing: 0,
    // Убираем жесткую ширину `SizedBox`, позволяя AppBar самому управлять размером лого
    leading: Padding(
      padding: const EdgeInsets.all(10.0), // Добавляем адекватный отступ
      child: SvgPicture.asset('assets/svg/logo.svg', fit: BoxFit.contain),
    ),
    title: Text('Меню', style: theme.textTheme.titleMedium),
    actions: [
      // Уменьшаем отступы и размеры иконок, чтобы они помещались на узких экранах
      IconButton(
        padding: const EdgeInsets.symmetric(horizontal: 6), // Уменьшенный отступ
        constraints: const BoxConstraints(), // Сбрасываем лишние ограничения по размеру
        icon: const Icon(Icons.list, size: 24), // Уменьшенный размер иконки
        onPressed: () {
          // context.router.push(const OrdersRoute());
        },
        tooltip: 'Заказы',
        hoverColor: Colors.white,
      ),
      IconButton(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        constraints: const BoxConstraints(),
        icon: const Icon(Icons.person, size: 24),
        onPressed: () {
          context.router.push(const ProfileRoute());
        },
        tooltip: 'Профиль',
        hoverColor: Colors.white,
      ),
      IconButton(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        constraints: const BoxConstraints(),
        icon: const Icon(Icons.info_outline, size: 24),
        tooltip: 'Адрес и телефон',
        onPressed: () {
          showMyAlertDialog(
            context,
            title: 'Контактная информация',
            content: 'Ханты-Мансийск, Калинина, 22\n+7 (999) 999-99-99',
          );
          // showDialog(
          //   context: context,
          //   builder: (context) => AlertDialog(
          //     title: const Text('Контактная информация', style: TextStyle(color: Colors.black)),
          //     content: const SingleChildScrollView(
          //       child: Column(
          //         mainAxisSize: MainAxisSize.min,
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text('Адрес:', style: TextStyle(color: Colors.black54)),
          //           Text(
          //             'Ханты-Мансийск, Калинина, 22',
          //             style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          //           ),
          //           SizedBox(height: 16),
          //           Text('Телефон:', style: TextStyle(color: Colors.black54)),
          //           Text(
          //             '+7 (999) 999-99-99',
          //             style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          //           ),
          //         ],
          //       ),
          //     ),
          //     actions: [
          //       TextButton(
          //         onPressed: () => Navigator.pop(context),
          //         child: const Center(child: Text('OK', style: TextStyle(color: Colors.black, fontSize: 18),)),
          //       ),
          //     ],
          //   ),
          // );
        },
        hoverColor: Colors.white,
        highlightColor: Colors.white,
      ),
      const SizedBox(width: 4), // Небольшой отступ в конце
    ],
  );
}

PreferredSizeWidget buildWideAppBar(BuildContext context) {
  final theme = Theme.of(context);
  
  return AppBar(
    automaticallyImplyLeading: false,
    centerTitle: false,
    titleSpacing: 0,
    leading: Padding(
      padding: const EdgeInsets.only(left: 10.0), // Add some left padding for the logo
      child: SizedBox(
        height: 40, // Adjusted to match icon button visual size
        width: 40,  // Adjusted to match icon button visual size
        child: SvgPicture.asset('assets/svg/logo.svg', fit: BoxFit.contain),
      ),
    ),
    title: Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0), // Adjusted padding
            child: TextButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft, // Ensure left alignment
              ),
              icon: Icon(
                Icons.location_city,
                color: theme.iconTheme.color,
                size: 24, // Adjusted icon size
              ),
              label: Text(
                'Ханты-Мансийск, Калинина, 22',
                style: theme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: null,
            ),
          ),
        ),
      ],
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
          '+7 (999) 999-99-99',
          style: theme.textTheme.titleLarge,
        ),
      ),
      IconButton(
        icon: const Icon(Icons.list),
        onPressed: () {
          // context.router.push(const OrdersRoute());
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