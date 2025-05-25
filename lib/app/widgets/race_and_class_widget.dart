import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dnd_app_char_sheet/app/data/character_manager.dart';

class CharacterDetailsWidget extends StatelessWidget {
  final String currentRace;
  final String currentClass;
  final String currentBackground;
  final String currentAlignment;

  const CharacterDetailsWidget({
    super.key,
    required this.currentRace,
    required this.currentClass,
    required this.currentBackground,
    required this.currentAlignment,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> raceOptions = [
      'Human', // Traduzido
      'Elf', // Traduzido
      'Dwarf', // Traduzido
      'Halfling', // Traduzido
      'Dragonborn', // Traduzido
      'Gnome', // Traduzido
      'Half-Orc', // Traduzido
      'Tiefling' // Traduzido
    ];
    final List<String> classOptions = [
      'Fighter', // Traduzido
      'Wizard', // Traduzido
      'Cleric', // Traduzido
      'Rogue', // Traduzido
      'Ranger', // Traduzido
      'Sorcerer', // Traduzido
      'Paladin', // Traduzido
      'Druid', // Traduzido
      'Barbarian', // Traduzido
      'Bard', // Traduzido
      'Monk', // Traduzido
      'Warlock', // Traduzido
      'Artificer' // Traduzido
    ];
    final List<String> backgroundOptions = [
      'Folk Hero', // Traduzido
      'Noble', // Traduzido
      'Soldier', // Traduzido
      'Urchin', // Traduzido
      'Sage', // Traduzido
      'Guild Artisan', // Traduzido
      'Criminal', // Traduzido
      'Outlander', // Traduzido
      'Acolyte' // Traduzido
    ];
    final List<String> alignmentOptions = [
      'Lawful Good', // Traduzido
      'Neutral Good', // Traduzido
      'Chaotic Good', // Traduzido
      'Lawful Neutral', // Traduzido
      'True Neutral', // Traduzido
      'Chaotic Neutral', // Traduzido
      'Lawful Evil', // Traduzido
      'Neutral Evil', // Traduzido
      'Chaotic Evil' // Traduzido
    ];

    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: [
        _buildAttributeChip(context, 'Race', currentRace, raceOptions), // Traduzido
        _buildAttributeChip(context, 'Class', currentClass, classOptions), // Traduzido
        _buildAttributeChip(
            context, 'Background', currentBackground, backgroundOptions), // Traduzido
        _buildAttributeChip(context, 'Alignment', currentAlignment, alignmentOptions), // Traduzido
      ],
    );
  }

  Widget _buildAttributeChip(BuildContext context, String title,
      String currentValue, List<String> options) {
    return ActionChip(
      label: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Text(title, style: Theme.of(context).textTheme.titleSmall),
          Text(currentValue, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
      onPressed: () =>
          _showOptionsDialog(context, title, currentValue, options),
    );
  }

  void _showOptionsDialog(BuildContext context, String title,
      String currentValue, List<String> options) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title:
          Text('Select $title', style: Theme.of(context).textTheme.titleLarge), // Traduzido
          children: [
            ...options.map((String value) => SimpleDialogOption(
              onPressed: () {
                _updateCharacterAttribute(context, title, value);
                Navigator.pop(context);
              },
              child: Text(value,
                  style: Theme.of(context).textTheme.bodyMedium),
            )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Manually Enter $title', // Traduzido
                ),
                onSubmitted: (String value) {
                  _updateCharacterAttribute(context, title, value);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _updateCharacterAttribute(
      BuildContext context, String attribute, String value) {
    final characterManager =
    Provider.of<CharacterManager>(context, listen: false);
    final updatedAttributes = {
      if (attribute == 'Race') 'race': value, // Traduzido
      if (attribute == 'Class') 'characterClass': value, // Traduzido
      if (attribute == 'Background') 'background': value, // Traduzido
      if (attribute == 'Alignment') 'alignment': value, // Traduzido
    };
    characterManager.updateCharacter(updatedAttributes);
  }
}