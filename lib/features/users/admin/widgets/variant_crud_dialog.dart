import 'package:flutter/material.dart';
import 'package:flutter_application_restaraunt/api_config.dart';

class VariantCrudDialog extends StatefulWidget {
  final int? initialProductId;
  final String? initialName;
  final int? initialPrice;
  final String? initialSku;
  final bool? initialIsAvailable;
  final bool? initialIsCombo;
  final String? initialDescription;
  final String? initialImageUrl;
  final int? initialValue;
  final String? initialUnit;
  final void Function(
      {required int productId,
      required String name,
      required int price,
      required String sku,
      required bool isAvailable,
      required bool isCombo,
      String? description,
      String? imageUrl,
      int? value,
      String? unit}) onSubmit;
  final void Function()? onHardDelete;
  final bool isEdit;

  const VariantCrudDialog({
    super.key,
    this.initialProductId,
    this.initialName,
    this.initialPrice,
    this.initialSku,
    this.initialIsAvailable,
    this.initialIsCombo,
    this.initialDescription,
    this.initialImageUrl,
    this.initialValue,
    this.initialUnit,
    required this.onSubmit,
    this.onHardDelete,
    this.isEdit = false,
  });

  @override
  State<VariantCrudDialog> createState() => _VariantCrudDialogState();
}

class _VariantCrudDialogState extends State<VariantCrudDialog> {
  late TextEditingController productIdController;
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController skuController;
  late TextEditingController descriptionController;
  late TextEditingController imageUrlController;
  late TextEditingController valueController;
  late TextEditingController unitController;
  bool isAvailable = false;
  bool isCombo = false;

  @override
  void initState() {
    super.initState();
    productIdController =
        TextEditingController(text: widget.initialProductId?.toString() ?? '');
    nameController = TextEditingController(text: widget.initialName ?? '');
    priceController =
        TextEditingController(text: widget.initialPrice?.toString() ?? '');
    skuController = TextEditingController(text: widget.initialSku ?? '');
    descriptionController =
        TextEditingController(text: widget.initialDescription ?? '');
    imageUrlController =
        TextEditingController(text: widget.initialImageUrl ?? '');
    valueController =
        TextEditingController(text: widget.initialValue?.toString() ?? '');
    unitController = TextEditingController(text: widget.initialUnit ?? '');
    isAvailable = widget.initialIsAvailable ?? false;
    isCombo = widget.initialIsCombo ?? false;
  }

  @override
  void dispose() {
    productIdController.dispose();
    nameController.dispose();
    priceController.dispose();
    skuController.dispose();
    descriptionController.dispose();
    imageUrlController.dispose();
    valueController.dispose();
    unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEdit ? 'Редактировать вариант' : 'Создать вариант'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: productIdController,
              decoration: const InputDecoration(
                labelText: 'ID продукта',
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
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'Цена',
                labelStyle: TextStyle(color: Colors.black),
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: skuController,
              decoration: const InputDecoration(
                labelText: 'SKU',
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: isAvailable,
                  onChanged: (val) =>
                      setState(() => isAvailable = val ?? false),
                ),
                const Text('Доступен', style: TextStyle(color: Colors.black)),
                Checkbox(
                  value: isCombo,
                  onChanged: (val) => setState(() => isCombo = val ?? false),
                ),
                const Text('Комбо', style: TextStyle(color: Colors.black)),
              ],
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Описание (опционально)',
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
            TextField(
              controller: imageUrlController,
              decoration: const InputDecoration(
                labelText: 'URL изображения (опционально)',
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
            TextField(
              controller: valueController,
              decoration: const InputDecoration(
                labelText: 'Значение (value, опционально)',
                labelStyle: TextStyle(color: Colors.black),
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: unitController,
              decoration: const InputDecoration(
                labelText: 'Единица измерения (unit, опционально)',
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
                      ApiConfig.apiSiteUrl+imageUrlController.text.trim(),
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
            final productId = int.tryParse(productIdController.text.trim());
            final name = nameController.text.trim();
            final price = int.tryParse(priceController.text.trim());
            final sku = skuController.text.trim();
            final description = descriptionController.text.trim().isEmpty
                ? null
                : descriptionController.text.trim();
            final imageUrl = imageUrlController.text.trim().isEmpty
                ? null
                : imageUrlController.text.trim();
            final value = valueController.text.trim().isEmpty
                ? null
                : int.tryParse(valueController.text.trim());
            final unit = unitController.text.trim().isEmpty
                ? null
                : unitController.text.trim();
            if (productId == null ||
                name.isEmpty ||
                price == null ||
                sku.isEmpty) return;
            widget.onSubmit(
              productId: productId,
              name: name,
              price: price,
              sku: sku,
              isAvailable: isAvailable,
              isCombo: isCombo,
              description: description,
              imageUrl: imageUrl,
              value: value,
              unit: unit,
            );
            Navigator.of(context).pop();
          },
          child: Text(widget.isEdit ? 'Сохранить' : 'Создать'),
        ),
      ],
    );
  }
}
