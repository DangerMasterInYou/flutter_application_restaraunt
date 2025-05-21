import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/hive/models/profile/profile.dart';
import '../bloc/profile_bloc.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({
    super.key,
    required this.profile,
  });

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 900),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 16),
            _buildInfoCard('Имя пользователя', profile.username ?? 'Не указано'),
            _buildInfoCard('Email', profile.email),
            _buildInfoCard('Фамилия', profile.familyName ?? 'Не указана'),
            _buildInfoCard('Телефон', profile.phone ?? 'Не указан'),
            _buildInfoCard('Дата рождения', profile.birthday != null 
                ? '${profile.birthday!.day}.${profile.birthday!.month}.${profile.birthday!.year}' 
                : 'Не указана'),
            _buildInfoCard('Статус', profile.isActive ? 'Активен' : 'Неактивен'),
            _buildInfoCard('Дата регистрации', 
                '${profile.createdAt.day}.${profile.createdAt.month}.${profile.createdAt.year}'),
            
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Здесь будет функционал сброса пароля
                context.read<ProfileBloc>().add(ResetPassword(profile: profile));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Функция сброса пароля пока не реализована')),
                );
              },
              child: const Text('Сбросить пароль'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: const BorderSide(color: Colors.white, width: 1),
      ),
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}