import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dnd_app_char_sheet/app/data/character_manager.dart'; // Presumindo que este import é necessário

class AttributeCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final int value;

  const AttributeCard({
    super.key,
    required this.name,
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final int modifier = value >= 10 ? (value - 10) ~/ 2 : (value - 11) ~/ 2;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
      child: InkWell(
        onTap: () => _showEditDialog(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon,
                        size: 14.0, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 2.0),
                    Flexible(
                      child: Text(
                        name, // This will be already in English if passed correctly from AttributesDisplay
                        style: textTheme.bodySmall?.copyWith(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$value',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${modifier >= 0 ? '+' : ''}$modifier',
                    style: textTheme.bodySmall?.copyWith(fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    int currentValue = value;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $name'), // Traduzido
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (currentValue > 0) {
                        setState(() => currentValue--);
                      }
                    },
                  ),
                  Text('$currentValue',
                      style: Theme.of(context).textTheme.headlineSmall),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => setState(() => currentValue++),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'), // Traduzido
            ),
            ElevatedButton(
              onPressed: () {
                // Presuming CharacterManager and updateAttribute are part of your app's logic
                Provider.of<CharacterManager>(context, listen: false)
                    .updateAttribute(name, currentValue);
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'), // Traduzido
            ),
          ],
        );
      },
    );
  }
}

class AttributesDisplay extends StatelessWidget {
  final List<int> attributes;

  const AttributesDisplay({super.key, required this.attributes});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.0,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 0.0,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: attributes.length,
      itemBuilder: (context, index) {
        final entry = attributes[index];
        return AttributeCard(
          name: _getAttributeName(index), // This method now returns English names
          icon: _getIconForAttribute(_getAttributeName(index)),
          value: entry,
        );
      },
    );
  }

  String _getAttributeName(int index) {
    switch (index) {
      case 0:
        return 'Strength'; // Traduzido
      case 1:
        return 'Dexterity'; // Traduzido
      case 2:
        return 'Constitution'; // Traduzido
      case 3:
        return 'Intelligence'; // Traduzido
      case 4:
        return 'Wisdom'; // Traduzido
      case 5:
        return 'Charisma'; // Traduzido
      default:
        return 'Unknown'; // Traduzido
    }
  }

  IconData _getIconForAttribute(String attributeName) {
    // Assuming these icons still make sense for the English attribute names
    switch (attributeName) {
      case 'Strength':
        return Icons.fitness_center;
      case 'Dexterity':
        return Icons.directions_run;
      case 'Constitution':
        return Icons.health_and_safety;
      case 'Intelligence':
        return Icons.school;
      case 'Wisdom':
        return Icons.visibility;
      case 'Charisma':
        return Icons.mood;
      default:
        return Icons.help_outline;
    }
  }
}