import 'package:flutter/material.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onLogout;
  const AdminAppBar({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Административная панель', style: TextStyle(color: Colors.black, fontSize: 20),),


      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Выйти',
          onPressed: onLogout,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
