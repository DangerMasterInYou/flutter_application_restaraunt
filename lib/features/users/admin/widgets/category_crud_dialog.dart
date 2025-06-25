import 'package:flutter/material.dart';

class CategoryCrudDialog extends StatefulWidget {
  final String? initialName;
  final int? initialSortOrder;
  final void Function(String name, int sortOrder) onSubmit;
  final void Function()? onHardDelete;
  final bool isEdit;

  const CategoryCrudDialog({
    super.key,
    this.initialName,
    this.initialSortOrder,
    required this.onSubmit,
    this.onHardDelete,
    this.isEdit = false,
  });

  @override
  State<CategoryCrudDialog> createState() => _CategoryCrudDialogState();
}

class _CategoryCrudDialogState extends State<CategoryCrudDialog> {
  late TextEditingController nameController;
  late TextEditingController sortOrderController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialName ?? '');
    sortOrderController =
        TextEditingController(text: widget.initialSortOrder?.toString() ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    sortOrderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Text(widget.isEdit ? 'Редактировать категорию' : 'Создать категорию'),
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
            TextField(
              controller: sortOrderController,
              decoration: const InputDecoration(
                labelText: 'Порядок сортировки',
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
            final sortOrder = int.tryParse(sortOrderController.text.trim());
            if (name.isEmpty || sortOrder == null) return;
            widget.onSubmit(name, sortOrder);
            Navigator.of(context).pop();
          },
          child: Text(widget.isEdit ? 'Сохранить' : 'Создать'),
        ),
      ],
    );
  }
}
