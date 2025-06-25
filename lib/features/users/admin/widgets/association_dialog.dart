import 'package:flutter/material.dart';

class AssociationDialog extends StatelessWidget {
  final List<String> allGroups;
  final List<String> selectedGroups;
  final void Function(List<String> selected) onSubmit;

  const AssociationDialog({
    super.key,
    required this.allGroups,
    required this.selectedGroups,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final Set<String> tempSelected = Set<String>.from(selectedGroups);
    return AlertDialog(
      title: const Text('Привязка групп модификаторов'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: allGroups.map((group) {
            return CheckboxListTile(
              value: tempSelected.contains(group),
              title: Text(group),
              onChanged: (checked) {
                if (checked == true) {
                  tempSelected.add(group);
                } else {
                  tempSelected.remove(group);
                }
                (context as Element).markNeedsBuild();
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            onSubmit(tempSelected.toList());
            Navigator.of(context).pop();
          },
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}
