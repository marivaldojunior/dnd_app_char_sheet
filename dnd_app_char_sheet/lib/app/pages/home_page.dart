import 'package:dnd_app_char_sheet/app/pages/skill_page.dart';
import 'package:dnd_app_char_sheet/app/pages/spell_collection_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

import '../data/character.dart';
import '../data/character_manager.dart';
import '../widgets/app_drawer_widget.dart';
import '../widgets/attributes_display_widget.dart';
import '../widgets/coin_display_widget.dart';
import '../widgets/combat_stats_widget.dart';
import '../widgets/consumable_widget.dart';
import '../widgets/dice_bag.dart';
import '../widgets/dice_row.dart';
import '../widgets/experience_bar_widget.dart';
import '../widgets/health_bar_widget.dart';
import '../widgets/race_and_class_widget.dart';
import 'backpack_page.dart';

class CharacterDisplayScreen extends StatefulWidget {
  CharacterDisplayScreen({super.key});

  @override
  _CharacterDisplayScreenState createState() => _CharacterDisplayScreenState();
}

class _CharacterDisplayScreenState extends State<CharacterDisplayScreen> {
  bool _isEditMode = false; // Add a state variable to track edit mode

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = image.name;
      final savedImage =
      await File(image.path).copy('${appDir.path}/$fileName');

      // Delete the old file
      if (Provider.of<CharacterManager>(context, listen: false)
          .character
          .avatarUrl
          .isNotEmpty) {
        final oldImage = File(
            Provider.of<CharacterManager>(context, listen: false)
                .character
                .avatarUrl);
        oldImage.deleteSync();
      }

      setState(() {
        // Assuming you have a method to update the character's avatarUrl
        Provider.of<CharacterManager>(context, listen: false)
            .updateCharacter({'avatarUrl': savedImage.path});
      });
    }
  }

  Future<void> _exportCharacter() async {
    // Let the user pick a directory
    String? outputPath = await FilePicker.platform.getDirectoryPath();

    if (outputPath != null) {
      final Character character =
          Provider.of<CharacterManager>(context, listen: false).character;
      final jsonString = jsonEncode(character.toJson());

      try {
        // Create the file path
        final now = DateTime.now();
        final timestamp =
            '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}'; // Generate a human-readable timestamp
        final filePath =
            '$outputPath/dndc_$timestamp.json'; // Update file path to include timestamp
        final file = File(filePath);

        await file.writeAsString(jsonString);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Character exported to $filePath')), // Traduzido: '角色已导出至 $filePath' para 'Character exported to $filePath'
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to export character: $e')), // Traduzido: '导出角色失败: $e' para 'Failed to export character: $e'
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export canceled')), // Traduzido: '导出已取消' para 'Export canceled'
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<CharacterManager>(
          builder: (context, manager, child) {
            return Text(manager.character.name);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(_isEditMode ? Icons.check : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditMode = !_isEditMode; // Toggle edit mode
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.download),
            onPressed: _exportCharacter,
            tooltip: 'Export Character', // Traduzido: '导出角色' para 'Export Character'
          ),
        ],
      ),
      drawer: AppDrawerWidget(),
      body: Consumer<CharacterManager>(
        builder: (context, manager, child) {
          final Character character = manager.character;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _isEditMode
                        ? _pickImage
                        : null, // Enable tap only in edit mode
                    child: character.avatarUrl.isNotEmpty
                        ? Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Builder(
                        builder: (context) {
                          try {
                            return ClipOval(
                              child: Image.file(
                                File(character.avatarUrl),
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                            );
                          } catch (e) {
                            // Show a SnackBar with an error message
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Failed to load image, displaying default.')), // Traduzido: '图片加载失败，显示默认图片。' para 'Failed to load image, displaying default.'
                              );
                            });
                            // Return a default image
                            return ClipOval(
                              child: Image.asset(
                                'assets/character.jpg',
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                            );
                          }
                        },
                      ),
                    )
                        : Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/character.jpg',
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  AbsorbPointer(
                    absorbing:
                    !_isEditMode, // Disable interaction when not in edit mode
                    child: CharacterDetailsWidget(
                      currentRace: character.race,
                      currentClass: character.characterClass,
                      currentBackground: character.background,
                      currentAlignment: character.alignment,
                    ),
                  ),
                  const SizedBox(height: 10),
                  AbsorbPointer(
                    absorbing:
                    !_isEditMode, // Disable interaction when not in edit mode
                    child: CombatStatsWidget(
                      armorClass: character.armorClass,
                      initiative: character.initiative,
                      speed: character.speed,
                    ),
                  ),
                  const SizedBox(height: 10),
                  AbsorbPointer(
                    absorbing:
                    !_isEditMode, // Disable interaction when not in edit mode
                    child: AttributesDisplay(attributes: character.attributes),
                  ),
                  ConsumableWidget(),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            HealthBar(
                                currentHitPoints: character.currentHitPoints,
                                maxHitPoints: character.maxHitPoints,
                                temporaryHitPoints:
                                character.temporaryHitPoints),
                            const SizedBox(height: 10),
                            ExperienceBar(
                                currentExperience: character.experiencePoints,
                                currentLevel: character.level),
                          ],
                        ),
                      ),
                      CoinDisplayWidget(coin: character.coin)
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0, // Espaçamento horizontal entre os botões
                    runSpacing: 4.0, // Espaçamento vertical entre as linhas (se houver quebra)
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SkillExpertiseScreen()));
                        },
                        child: Text('Skills & Feats'), // Traduzido: '技能专长' para 'Skills & Feats'
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BackpackPage()));
                        },
                        child: Text('Backpack'), // Traduzido: '背包' para 'Backpack'
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SpellCollectionScreen()));
                        },
                        child: Text('Spell Collection'), // Traduzido: '法术收藏' para 'Spell Collection'
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Divider(
                    color: const Color.fromARGB(255, 78, 76, 76),
                    thickness: 2.0,
                  ),
                  const SizedBox(
                      height: 20), // Larger spacing to distinguish boundaries
                  DiceRow(),
                  DiceBagWidget(diceBag: character.diceBag),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}