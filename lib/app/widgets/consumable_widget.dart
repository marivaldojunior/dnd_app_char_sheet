import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dnd_app_char_sheet/app/data/character_manager.dart';
import 'package:dnd_app_char_sheet/app/data/consumable.dart';

class ConsumableWidget extends StatelessWidget {
  const ConsumableWidget({super.key});

@override
Widget build(BuildContext context) {
  return Consumer<CharacterManager>(
    builder: (context, manager, child) {
      final consumables = manager.character.consumables;

      return SingleChildScrollView(
        child: Column(
          children: [
            Wrap(
              spacing: 8.0, // Espaçamento horizontal entre os botões
              runSpacing: 4.0, // Espaçamento vertical entre as linhas (se houver quebra)
              children: [
                ElevatedButton(
                  onPressed: manager.triggerShortRest,
                  child: const Text('Short Rest'), // Traduzido: '短休' para 'Short Rest'
                ),
                ElevatedButton(
                  onPressed: manager.triggerLongRest,
                  child: const Text('Long Rest'), // Traduzido: '长休' para 'Long Rest'
                ),
                ElevatedButton(
                  onPressed: () => _showAddConsumableDialog(context),
                  child: const Text('Add Consumable'), // Traduzido: '添加消耗品' para 'Add Consumable'
                ),
              ],
            ),
            Wrap(
              spacing: 4.0,
              runSpacing: 4.0,
              children: consumables.map((consumable) {
                return GestureDetector(
                  onTap: () {
                    consumable.decrease();
                    manager.updateConsumable(consumable);
                  },
                  onDoubleTap: () {
                    consumable.increase();
                    manager.updateConsumable(consumable);
                  },
                  onLongPress: () {
                    _showEditConsumableDialog(context, consumable, manager);
                  },
                  child: Card(
                    elevation: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 6.0),
                      constraints: const BoxConstraints(minWidth: 80.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            consumable.name,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${consumable.currentCount}/${consumable.maxCount}',
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const Divider(
              color: Color.fromARGB(255, 184, 184, 184),
              thickness: 2.0,
            ),
          ],
        ),
      );
    },
  );
}

void _showAddConsumableDialog(BuildContext context) {
  String name = '';
  int maxCount = 0;
  int shortRestRecovery = 0;
  int longRestRecovery = 0;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add Consumable'), // Traduzido: '添加消耗品' para 'Add Consumable'
        content: SingleChildScrollView(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Name'), // Traduzido: '名称' para 'Name'
                    onChanged: (value) {
                      name = value;
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Max Quantity'), // Traduzido: '最大数量' para 'Max Quantity'
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      maxCount = int.tryParse(value) ?? 0;
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Short Rest Recovery'), // Traduzido: '短休恢复量' para 'Short Rest Recovery'
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      shortRestRecovery = int.tryParse(value) ?? 0;
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Long Rest Recovery'), // Traduzido: '长休恢复量' para 'Long Rest Recovery'
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      longRestRecovery = int.tryParse(value) ?? 0;
                    },
                  ),
                ],
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'), // Traduzido: '取消' para 'Cancel'
          ),
          TextButton(
            onPressed: () {
              if (name.isNotEmpty) {
                final newConsumable = Consumable(
                  name: name,
                  currentCount: maxCount,
                  maxCount: maxCount,
                  shortRestRecovery: shortRestRecovery,
                  longRestRecovery: longRestRecovery,
                );
                Provider.of<CharacterManager>(context, listen: false)
                    .addConsumable(newConsumable);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'), // Traduzido: '添加' para 'Add'
          ),
        ],
      );
    },
  );
}

void _showEditConsumableDialog(
    BuildContext context, Consumable consumable, CharacterManager manager) {
  String name = consumable.name;
  int maxCount = consumable.maxCount;
  int shortRestRecovery = consumable.shortRestRecovery;
  int longRestRecovery = consumable.longRestRecovery;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Edit Consumable'), // Traduzido: '编辑消耗品' para 'Edit Consumable'
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Name'), // Traduzido: '名称' para 'Name'
              onChanged: (value) {
                name = value;
              },
              controller: TextEditingController(text: name),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Max Quantity'), // Traduzido: '最大数量' para 'Max Quantity'
              keyboardType: TextInputType.number,
              onChanged: (value) {
                maxCount = int.tryParse(value) ?? maxCount;
              },
              controller: TextEditingController(text: maxCount.toString()),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Short Rest Recovery'), // Traduzido: '短休恢复量' para 'Short Rest Recovery'
              keyboardType: TextInputType.number,
              onChanged: (value) {
                shortRestRecovery = int.tryParse(value) ?? shortRestRecovery;
              },
              controller:
              TextEditingController(text: shortRestRecovery.toString()),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Long Rest Recovery'), // Traduzido: '长休恢复量' para 'Long Rest Recovery'
              keyboardType: TextInputType.number,
              onChanged: (value) {
                longRestRecovery = int.tryParse(value) ?? longRestRecovery;
              },
              controller:
              TextEditingController(text: longRestRecovery.toString()),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (name.isNotEmpty) {
                consumable.name = name;
                consumable.maxCount = maxCount;
                consumable.shortRestRecovery = shortRestRecovery;
                consumable.longRestRecovery = longRestRecovery;
                manager.updateConsumable(consumable);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'), // Traduzido: '保存' para 'Save'
          ),
          GestureDetector(
            onDoubleTap: () {
              manager.deleteConsumable(consumable);
              Navigator.of(context).pop();
            },
            child: const Text(
              'Delete (Double Tap)', // Traduzido: '删除(双击)' para 'Delete (Double Tap)'
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}
}