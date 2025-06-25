import 'package:flutter/material.dart';

class ModifierCrudDialog extends StatefulWidget {
  final String? initialName;
  final int? initialPriceDelta;
  final int? initialGroupId;
  final List<Map<String, dynamic>> groups; // [{id: int, name: String}]
  final void Function(String name, int priceDelta, int groupId) onSubmit;
  final void Function()? onHardDelete;
  final bool isEdit;

  const ModifierCrudDialog({
    super.key,
    this.initialName,
    this.initialPriceDelta,
    this.initialGroupId,
    required this.groups,
    required this.onSubmit,
    this.onHardDelete,
    this.isEdit = false,
  });

  @override
  State<ModifierCrudDialog> createState() => _ModifierCrudDialogState();
}

class _ModifierCrudDialogState extends State<ModifierCrudDialog> {
  late TextEditingController nameController;
  late TextEditingController priceDeltaController;
  int? selectedGroupId;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialName ?? '');
    priceDeltaController =
        TextEditingController(text: widget.initialPriceDelta?.toString() ?? '');
    selectedGroupId = widget.initialGroupId ??
        (widget.groups.isNotEmpty ? widget.groups.first['id'] as int : null);
  }

  @override
  void dispose() {
    nameController.dispose();
    priceDeltaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          widget.isEdit ? 'Редактировать модификатор' : 'Создать модификатор'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<int>(
              value: selectedGroupId,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black), // ADDED HERE for text style
              items: widget.groups
                  .map((g) => DropdownMenuItem<int>(
                        value: g['id'] as int,
                        child: Text(g['name'] as String, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black)), // ADDED HERE for item text style
                      ))
                  .toList(),
              onChanged: (val) => setState(() => selectedGroupId = val),
              decoration: const InputDecoration(
                labelText: 'Группа модификаторов',
                labelStyle: TextStyle(color: Colors.black),
              ),
              validator: (value) { // ADDED HERE for validation
                if (value == null) {
                  return 'Пожалуйста, выберите группу';
                }
                return null;
              },
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Название',
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
            TextField(
              controller: priceDeltaController,
              decoration: const InputDecoration(
                labelText: 'Изменение цены',
                labelStyle: TextStyle(color: Colors.black),
              ),
              keyboardType: TextInputType.number,
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
            final priceDelta = int.tryParse(priceDeltaController.text.trim());
            if (name.isEmpty || priceDelta == null || selectedGroupId == null) return; // MODIFIED HERE to check selectedGroupId
            widget.onSubmit(name, priceDelta, selectedGroupId!);
            Navigator.of(context).pop();
          },
          child: Text(widget.isEdit ? 'Сохранить' : 'Создать'),
        ),
      ],
    );
  }
}
