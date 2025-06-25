import 'package:flutter/material.dart';
import 'package:flutter_application_restaraunt/api_config.dart';

class ProductCrudDialog extends StatefulWidget {
  final int? initialCategoryId;
  final String? initialName;
  final String? initialDescription;
  final int? initialSortOrder;
  final String? initialImageUrl;
  final void Function(int categoryId, String name, String? description,
      int sortOrder, String imageUrl) onSubmit;
  final void Function()? onHardDelete;
  final bool isEdit;

  const ProductCrudDialog({
    super.key,
    this.initialCategoryId,
    this.initialName,
    this.initialDescription,
    this.initialSortOrder,
    this.initialImageUrl,
    required this.onSubmit,
    this.onHardDelete,
    this.isEdit = false,
  });

  @override
  State<ProductCrudDialog> createState() => _ProductCrudDialogState();
}

class _ProductCrudDialogState extends State<ProductCrudDialog> {
  late TextEditingController categoryIdController;
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController sortOrderController;
  late TextEditingController imageUrlController;

  @override
  void initState() {
    super.initState();
    categoryIdController =
        TextEditingController(text: widget.initialCategoryId?.toString() ?? '');
    nameController = TextEditingController(text: widget.initialName ?? '');
    descriptionController =
        TextEditingController(text: widget.initialDescription ?? '');
    sortOrderController =
        TextEditingController(text: widget.initialSortOrder?.toString() ?? '');
    imageUrlController =
        TextEditingController(text: widget.initialImageUrl ?? '');
  }

  @override
  void dispose() {
    categoryIdController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    sortOrderController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEdit ? 'Редактировать продукт' : 'Создать продукт'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: categoryIdController,
              decoration: const InputDecoration(
                labelText: 'ID категории',
                labelStyle: TextStyle(color: Colors.black),
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Название',
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Описание (опционально)',
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
            TextField(
              controller: imageUrlController,
              decoration: const InputDecoration(
                labelText: 'URL изображения',
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
            if (imageUrlController.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      ApiConfig.apiSiteUrl+imageUrlController.text,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error, color: Colors.red);
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                ),
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
            final categoryId = int.tryParse(categoryIdController.text.trim());
            final name = nameController.text.trim();
            final description = descriptionController.text.trim().isEmpty
                ? null
                : descriptionController.text.trim();
            final sortOrder = int.tryParse(sortOrderController.text.trim());
            final imageUrl = imageUrlController.text.trim();
            if (categoryId == null ||
                name.isEmpty ||
                sortOrder == null ||
                imageUrl.isEmpty) return;
            widget.onSubmit(categoryId, name, description, sortOrder, imageUrl);
            Navigator.of(context).pop();
          },
          child: Text(widget.isEdit ? 'Сохранить' : 'Создать'),
        ),
      ],
    );
  }
}
