import 'package:flutter/material.dart';

class ModifierGroupCrudDialog extends StatefulWidget {
  final String? initialName;
  final bool? initialIsRequired;
  final bool? initialIsMultiselect;
  final void Function(String name, bool isRequired, bool isMultiselect)
      onSubmit;
  final void Function()? onHardDelete;
  final bool isEdit;

  const ModifierGroupCrudDialog({
    super.key,
    this.initialName,
    this.initialIsRequired,
    this.initialIsMultiselect,
    required this.onSubmit,
    this.onHardDelete,
    this.isEdit = false,
  });

  @override
  State<ModifierGroupCrudDialog> createState() =>
      _ModifierGroupCrudDialogState();
}

class _ModifierGroupCrudDialogState extends State<ModifierGroupCrudDialog> {
  late TextEditingController nameController;
  bool isRequired = false;
  bool isMultiselect = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialName ?? '');
    isRequired = widget.initialIsRequired ?? false;
    isMultiselect = widget.initialIsMultiselect ?? false;
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEdit
          ? 'Редактировать группу модификаторов'
          : 'Создать группу модификаторов'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Название',
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: isRequired,
                  onChanged: (val) => setState(() => isRequired = val ?? false),
                  activeColor: Colors.black,
                  checkColor: Colors.white,
                ),
                const Text('Обязательная группа',
                    style: TextStyle(color: Colors.black)),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: isMultiselect,
                  onChanged: (val) =>
                      setState(() => isMultiselect = val ?? false),
                  activeColor: Colors.black,
                  checkColor: Colors.white,
                ),
                const Text('Множественный выбор',
                    style: TextStyle(color: Colors.black)),
              ],
            ),
          ],
        ),
      ),
      actions: [
        if (widget.isEdit && widget.onHardDelete != null)
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: widget.onHardDelete,
            child: const Text('Жёстко удалить'),
          ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = nameController.text.trim();
            if (name.isEmpty) return;
            widget.onSubmit(name, isRequired, isMultiselect);
            Navigator.of(context).pop();
          },
          child: Text(widget.isEdit ? 'Сохранить' : 'Создать'),
        ),
      ],
    );
  }
}
