// profile_content.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '/core/repositories/users/client/profile/profile.dart';
import '../bloc/profile_bloc.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({
    super.key,
    required this.profile,
  });

  final ProfileResponse profile;

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  bool _isEditing = false;

  late TextEditingController _usernameController;
  late TextEditingController _familyNameController;
  late TextEditingController _phoneController;
  late TextEditingController _birthdayController;

  final DateFormat _dateFormat = DateFormat('dd.MM.yyyy');
  final _phoneMaskFormatter = MaskTextInputFormatter(
    mask: '+7 (###) ###-##-##', filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void didUpdateWidget(covariant ProfileContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.profile.id != oldWidget.profile.id && !_isEditing) {
      _initializeControllers();
    }
  }

  void _initializeControllers() {
    _usernameController = TextEditingController(text: widget.profile.username ?? '');
    _familyNameController = TextEditingController(text: widget.profile.familyName ?? '');
    _phoneController = TextEditingController(text: widget.profile.phone ?? '');
    _birthdayController = TextEditingController(
        text: widget.profile.birthday != null
            ? _dateFormat.format(widget.profile.birthday!)
            : '');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _familyNameController.dispose();
    _phoneController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  void _toggleEditState() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) _initializeControllers();
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
    
    final patchDto = ProfilePatchDTO(
      username: _usernameController.text != (widget.profile.username ?? '') ? _usernameController.text : null,
      familyName: _familyNameController.text != (widget.profile.familyName ?? '') ? _familyNameController.text : null,
      phone: _phoneController.text != (widget.profile.phone ?? '') ? _phoneController.text : null,
      birthday: birthdayDate?.toIso8601String() != widget.profile.birthday?.toIso8601String() ? birthdayDate : null,
    );
    
    if (patchDto.toJson().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Нет изменений для сохранения')),
        );
        _toggleEditState();
        return;
    }
    
    context.read<ProfileBloc>().add(UpdateProfile(patchDto: patchDto));
    setState(() => _isEditing = false);
  }

  void _confirmDeleteProfile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удаление профиля'),
        content: const Text('Вы уверены, что хотите безвозвратно удалить свой профиль? Все ваши данные будут стерты.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Отмена')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<ProfileBloc>().add(const DeleteProfile());
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      alignment: Alignment.center,
      color: Colors.black,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Container(
            padding: EdgeInsets.all(screenWidth > 400 ? 24.0 : 16.0),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Личные данные',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _buildProfileField(
                  label: 'Имя',
                  icon: Icons.person_outline,
                  controller: _usernameController,
                  isEditable: true,
                ),
                _buildProfileField(
                  label: 'Фамилия',
                  icon: Icons.person_outline,
                  controller: _familyNameController,
                  isEditable: true,
                ),
                _buildProfileField(
                  label: 'Email',
                  icon: Icons.email_outlined,
                  controller: TextEditingController(text: widget.profile.email),
                  isEditable: false,
                ),
                _buildProfileField(
                  label: 'Телефон',
                  icon: Icons.phone_outlined,
                  controller: _phoneController,
                  isEditable: true,
                  keyboardType: TextInputType.phone,
                  formatter: _phoneMaskFormatter,
                ),
                _buildProfileField(
                  label: 'Дата рождения',
                  icon: Icons.cake_outlined,
                  controller: _birthdayController,
                  isEditable: true,
                  // ИСПРАВЛЕННАЯ СТРОКА
                  onTap: _isEditing ? _selectDate : null,
                ),
                const SizedBox(height: 32),
                if (_isEditing) ...[
                  ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Сохранить', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _toggleEditState,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3A3A3C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Отмена'),
                  ),
                ] else ...[
                  ElevatedButton(
                    onPressed: _toggleEditState,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Редактировать профиль', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: _confirmDeleteProfile,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Color(0xFF552525)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Удалить профиль'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool isEditable = false,
    TextInputType? keyboardType,
    MaskTextInputFormatter? formatter,
    Future<void> Function()? onTap,
  }) {
    final isReadOnly = !_isEditing || !isEditable;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            readOnly: isReadOnly || onTap != null, // Делаем поле readonly, если есть onTap
            onTap: onTap,
            keyboardType: keyboardType,
            inputFormatters: formatter != null ? [formatter] : [],
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              filled: true,
              fillColor: isReadOnly ? const Color(0xFF2C2C2E) : const Color(0xFF3A3A3C),
              prefixIcon: Icon(icon, color: Colors.grey[400]),
              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: isReadOnly 
                ? null 
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white, width: 1.5),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateFormat.tryParse(_birthdayController.text) ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('ru', 'RU'),
    );
    if (picked != null) {
      setState(() {
        _birthdayController.text = _dateFormat.format(picked);
      });
    }
  }
}