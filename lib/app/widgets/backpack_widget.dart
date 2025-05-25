import 'package:flutter/material.dart';
import 'package:dnd_app_char_sheet/app/data/items.dart';
import 'package:dnd_app_char_sheet/app/data/character_manager.dart';
import 'package:provider/provider.dart';

class BackpackWidget extends StatelessWidget {
  final List<Item> backpack;

  const BackpackWidget({
    Key? key,
    required this.backpack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.all(8),
          child: Stack(
            children: [
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: backpack.length,
                  itemBuilder: (context, index) {
                    final item = backpack[index];
                    return ListTile(
                      title: Text(item.name,
                          style: Theme.of(context).textTheme.bodySmall),
                      subtitle: Text(item.description),
                      trailing: Text('Qty: ${item.quantity}'), // Traduzido: "数量" para "Qty"
                      onLongPress: () {
                        _showEditDialog(context, item);
                      },
                    );
                  },
                ),
              ),
              Positioned(
                left: -8,
                top: -8,
                child: GestureDetector(
                  onLongPress: () {
                    _showAddItemDialog(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Item item) {
    String itemName = item.name;
    int itemQuantity = item.quantity;
    String itemDescription = item.description;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Item: $itemName'), // Traduzido: "编辑物品" para "Edit Item"
          content: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Item Name'), // Traduzido: "物品名称" para "Item Name"
                      onChanged: (value) {
                        itemName = value;
                      },
                      controller: TextEditingController(text: itemName),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Quantity'), // Traduzido: "数量" para "Quantity"
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        itemQuantity = int.tryParse(value) ?? itemQuantity;
                      },
                      controller:
                      TextEditingController(text: itemQuantity.toString()),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Description'), // Traduzido: "描述" para "Description"
                      onChanged: (value) {
                        itemDescription = value;
                      },
                      controller: TextEditingController(text: itemDescription),
                    ),
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Apply Changes'), // Traduzido: "应用修改" para "Apply Changes"
              onPressed: () {
                CharacterManager characterManager =
                Provider.of<CharacterManager>(context, listen: false);
                characterManager.deleteItem(item.uniqueId);
                characterManager.addItem(Item(
                  name: itemName,
                  quantity: itemQuantity,
                  description: itemDescription,
                ));
                Navigator.of(context).pop();
              },
            ),
            GestureDetector(
              onDoubleTap: () {
                CharacterManager characterManager =
                Provider.of<CharacterManager>(context, listen: false);
                characterManager.deleteItem(item.uniqueId);
                Navigator.of(context).pop();
              },
              child: TextButton(
                child: const Text('Delete (Double Tap to Confirm)'), // Traduzido: "删除（双击确认）" para "Delete (Double Tap to Confirm)"
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please double tap to confirm deletion')), // Traduzido: "请双击确认删除" para "Please double tap to confirm deletion"
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddItemDialog(BuildContext context) {
    String itemName = '';
    int itemQuantity = 1;
    String itemDescription = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Item'), // Traduzido: "添加新物品" para "Add New Item"
          content: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Item Name'), // Traduzido: "物品名称" para "Item Name"
                      onChanged: (value) {
                        itemName = value;
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Quantity'), // Traduzido: "数量" para "Quantity"
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        itemQuantity = int.tryParse(value) ?? itemQuantity;
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Description'), // Traduzido: "描述" para "Description"
                      onChanged: (value) {
                        itemDescription = value;
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Add Item'), // Traduzido: "添加物品" para "Add Item"
              onPressed: () {
                if (itemName.isNotEmpty) {
                  CharacterManager characterManager =
                  Provider.of<CharacterManager>(context, listen: false);
                  characterManager.addItem(Item(
                    name: itemName,
                    quantity: itemQuantity,
                    description: itemDescription,
                  ));
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}