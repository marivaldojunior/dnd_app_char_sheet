import 'package:flutter/material.dart';
import 'package:dnd_app_char_sheet/app/data/character_manager.dart';
import 'package:dnd_app_char_sheet/app/data/items.dart';
import 'package:provider/provider.dart';

class BackpackPage extends StatefulWidget {
  const BackpackPage({super.key});

  @override
  BackpackPageState createState() => BackpackPageState();
}

class BackpackPageState extends State<BackpackPage> {
  bool _isEditMode = false;
  bool _isDeleteMode = false;

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      _isDeleteMode =
      false; // Ensure delete mode is off when entering edit mode
    });
  }

  void _toggleDeleteMode() {
    setState(() {
      _isDeleteMode = !_isDeleteMode;
      _isEditMode = false; // Ensure edit mode is off when entering delete mode
    });
  }

  void _incrementItemQuantity(BuildContext context, Item item) {
    Provider.of<CharacterManager>(context, listen: false)
        .updateItemQuantity(item, item.quantity + 1);
  }

  void _decrementItemQuantity(BuildContext context, Item item) {
    if (item.quantity > 0) {
      Provider.of<CharacterManager>(context, listen: false)
          .updateItemQuantity(item, item.quantity - 1);
    }
  }

  void _deleteItem(BuildContext context, Item item) {
    Provider.of<CharacterManager>(context, listen: false)
        .deleteItem(item.uniqueId);
  }

  void _editItemDetails(BuildContext context, Item item) {
    String itemName = item.name;
    int itemQuantity = item.quantity;
    String itemDescription = item.description;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Item: $itemName'), // Traduzido: '编辑物品' para 'Edit Item'
          content: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Item Name'), // Traduzido: '物品名称' para 'Item Name'
                      onChanged: (value) {
                        itemName = value;
                      },
                      controller: TextEditingController(text: itemName),
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Quantity'), // Traduzido: '数量' para 'Quantity'
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        itemQuantity = int.tryParse(value) ?? itemQuantity;
                      },
                      controller:
                      TextEditingController(text: itemQuantity.toString()),
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Description'), // Traduzido: '描述' para 'Description'
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
              child: const Text('Apply Changes'), // Traduzido: '应用修改' para 'Apply Changes'
              onPressed: () {
                Provider.of<CharacterManager>(context, listen: false)
                    .updateItem(
                  item.copyWith(
                    name: itemName,
                    quantity: itemQuantity,
                    description: itemDescription,
                  ),
                );
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'), // Traduzido: '取消' para 'Cancel'
              onPressed: () {
                Navigator.of(context).pop();
              },
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
          title: const Text('Add New Item'), // Traduzido: '添加新物品' para 'Add New Item'
          content: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Item Name'), // Traduzido: '物品名称' para 'Item Name'
                      onChanged: (value) {
                        itemName = value;
                      },
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Quantity'), // Traduzido: '数量' para 'Quantity'
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        itemQuantity = int.tryParse(value) ?? itemQuantity;
                      },
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Description'), // Traduzido: '描述' para 'Description'
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
              child: const Text('Add Item'), // Traduzido: '添加物品' para 'Add Item'
              onPressed: () {
                if (itemName.isNotEmpty) {
                  Provider.of<CharacterManager>(context, listen: false).addItem(
                    Item(
                      name: itemName,
                      quantity: itemQuantity,
                      description: itemDescription,
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
            TextButton(
              child: const Text('Cancel'), // Traduzido: '取消' para 'Cancel'
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backpack'), // Traduzido: '背包' para 'Backpack'
        actions: [
          IconButton(
            icon: Icon(_isEditMode ? Icons.check : Icons.edit),
            onPressed: () {
              if (_isEditMode) {
// Save sorted list to database
                _saveSortedItems(context);
              }
              _toggleEditMode();
            },
            tooltip: _isEditMode ? 'Finish Editing' : 'Edit', // Traduzido
          ),
          IconButton(
            icon: Icon(_isDeleteMode ? Icons.check : Icons.delete),
            onPressed: _toggleDeleteMode,
            tooltip: _isDeleteMode ? 'Finish Deleting' : 'Delete', // Traduzido
          ),
        ],
      ),
      body: Consumer<CharacterManager>(
        builder: (context, manager, child) {
          final backpack = manager.character.backpack;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ReorderableListView.builder(
              itemCount: backpack.length,
              onReorder: (oldIndex, newIndex) {
                if (newIndex > oldIndex) newIndex--;
                final item = backpack.removeAt(oldIndex);
                backpack.insert(newIndex, item);
// Update order in database
                _saveSortedItems(context);
              },
              itemBuilder: (context, index) {
                final item = backpack[index];
                return Card(
                  key: ValueKey(item.uniqueId), // Ensure each card has a unique key
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    title: Text(item.name),
                    subtitle: Text(item.description),
                    trailing: _isEditMode
                        ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, color: Colors.red),
                          onPressed: () =>
                              _decrementItemQuantity(context, item),
                          tooltip: 'Decrease Quantity', // Traduzido
                        ),
                        Text('Quantity: ${item.quantity}'), // Traduzido
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.green),
                          onPressed: () =>
                              _incrementItemQuantity(context, item),
                          tooltip: 'Increase Quantity', // Traduzido
                        ),
                      ],
                    )
                        : _isDeleteMode
                        ? IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteItem(context, item),
                      tooltip: 'Delete Item', // Traduzido
                    )
                        : Text('Quantity: ${item.quantity}'), // Traduzido
                    onLongPress: _isEditMode
                        ? null
                        : () => _editItemDetails(context, item), // Disable long press edit
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemDialog(context),
        tooltip: 'Add New Item',
        child: const Icon(Icons.add), // Traduzido: '添加新物品' para 'Add New Item'
      ),
    );
  }

// New method: Save sorted list to database
  void _saveSortedItems(BuildContext context) {
    final manager = Provider.of<CharacterManager>(context, listen: false);
    manager.updateBackpackOrder(manager.character.backpack);
  }
}