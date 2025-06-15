import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '/core/hive/models/profile/profile.dart';
import '../bloc/profile_bloc.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({
    super.key,
    required this.profile,
  });

  final Profile profile;

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  bool _isEditing = false;

  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _familyNameController;
  late TextEditingController _phoneController;
  late TextEditingController _birthdayController;

  final DateFormat _dateFormat = DateFormat('dd.MM.yyyy');

  final _phoneMaskFormatter = MaskTextInputFormatter(
    mask: '+7 (###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.profile.username);
    _emailController = TextEditingController(text: widget.profile.email);
    _familyNameController = TextEditingController(text: widget.profile.familyName);
    _phoneController = TextEditingController(text: widget.profile.phone);
    _birthdayController = TextEditingController(
        text: widget.profile.birthday != null
            ? _dateFormat.format(widget.profile.birthday!)
            : '');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _familyNameController.dispose();
    _phoneController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  void _toggleEditState() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        _usernameController.text = widget.profile.username ?? '';
        _emailController.text = widget.profile.email;
        _familyNameController.text = widget.profile.familyName ?? '';
        _phoneController.text = widget.profile.phone ?? '';
        _birthdayController.text = widget.profile.birthday != null
            ? _dateFormat.format(widget.profile.birthday!)
            : '';
      }
    });
  }

  void _saveProfile() {
    if (_phoneController.text.isNotEmpty && !_phoneMaskFormatter.isFill()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите полный номер телефона')),
      );
        return;
    }

    DateTime? birthdayDate;
    if (_birthdayController.text.isNotEmpty) {
      try {
        birthdayDate = _dateFormat.parse(_birthdayController.text);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Неверный формат даты. Используйте ДД.ММ.ГГГГ')),
        );
        return;
      }
    }

    final updatedProfile = widget.profile;

    context.read<ProfileBloc>().add(UpdateProfile(profile: updatedProfile));
    _toggleEditState();
     ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Профиль сохранен (имитация)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isWideScreen = screenSize.width > 600;
    
    return Center(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Container(
          width: isWideScreen ? 600 : screenSize.width * 0.9,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  child: Icon(Icons.person, size: 80),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Профиль пользователя',
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Управление личными данными',
                style: theme.textTheme.labelSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _buildInfoRow('Имя пользователя', _usernameController, isEditable: true, originalValue: widget.profile.username ?? 'Не указано'),
              _buildInfoRow('Email', _emailController, isEditable: false, originalValue: widget.profile.email),
              _buildInfoRow('Фамилия', _familyNameController, isEditable: true, originalValue: widget.profile.familyName ?? 'Не указана'),
              _buildInfoRow('Телефон', _phoneController, isEditable: true, keyboardType: TextInputType.phone, originalValue: widget.profile.phone ?? 'Не указан', formatter: _phoneMaskFormatter, validator: (value) {
                if (value != null && value.isNotEmpty && !_phoneMaskFormatter.isFill()) {
                  return 'Введите полный номер';
                }
                return null;
              }),
              _buildInfoRow('Дата рождения', _birthdayController, isEditable: true, keyboardType: TextInputType.datetime, hintText: 'ДД.ММ.ГГГГ', originalValue: widget.profile.birthday != null
                  ? _dateFormat.format(widget.profile.birthday!)
                  : 'Не указана', onTap: _selectDate),
              _buildReadOnlyInfoCard('Статус', widget.profile.isActive ? 'Активен' : 'Неактивен'),
              _buildReadOnlyInfoCard('Дата регистрации', 
                  _dateFormat.format(widget.profile.createdAt)),
              
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isEditing ? _saveProfile : _toggleEditState,
                child: Text(_isEditing ? 'Сохранить' : 'Редактировать'),
              ),
              if (_isEditing)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _toggleEditState,
                    child: const Text('Отмена'),
                  ),
                ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<ProfileBloc>().add(ResetPassword(profile: widget.profile));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Функция сброса пароля пока не реализована')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Сбросить пароль'),
            ),
          ],
        ),
      ),
    ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.profile.birthday ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('ru', 'RU'),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _birthdayController.text = _dateFormat.format(picked);
      });
    }
  }

  Widget _buildInfoRow(String title, TextEditingController controller, {bool isEditable = true, TextInputType? keyboardType, String? hintText, required String originalValue, MaskTextInputFormatter? formatter, Future<void> Function(BuildContext)? onTap, String? Function(String?)? validator}) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _isEditing && isEditable
              ? TextFormField(
                  controller: controller,
                  style: theme.textTheme.bodyMedium,
                  keyboardType: keyboardType,
                  inputFormatters: formatter != null ? [formatter] : [],
                  decoration: InputDecoration(
                    hintText: hintText,
                    prefixIcon: _getIconForField(title),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: theme.scaffoldBackgroundColor.withOpacity(0.5),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                    errorStyle: const TextStyle(color: Colors.redAccent),
                  ),
                  readOnly: onTap != null,
                  onTap: onTap != null ? () => onTap(context) : null,
                  validator: validator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                )
              : Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withOpacity(0.5)),
                    color: theme.scaffoldBackgroundColor.withOpacity(0.5),
                  ),
                  child: Row(
                    children: [
                      _getIconForField(title),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          controller.text.isNotEmpty ? controller.text : originalValue, 
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
  
  Widget _getIconForField(String fieldName) {
    switch (fieldName) {
      case 'Имя пользователя':
        return const Icon(Icons.person_outline);
      case 'Email':
        return const Icon(Icons.email_outlined);
      case 'Фамилия':
        return const Icon(Icons.person_outline);
      case 'Телефон':
        return const Icon(Icons.phone_outlined);
      case 'Дата рождения':
        return const Icon(Icons.calendar_today_outlined);
      default:
        return const Icon(Icons.info_outline);
    }
  }

  Widget _buildReadOnlyInfoCard(String title, String value) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.5)),
              color: theme.scaffoldBackgroundColor.withOpacity(0.5),
            ),
            child: Row(
              children: [
                _getIconForField(title),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}