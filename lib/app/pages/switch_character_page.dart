import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';
import '../data/character.dart';
import '../data/character_manager.dart';

class SwitchCharacterScreen extends StatefulWidget {
  const SwitchCharacterScreen({super.key});

  @override
  SwitchCharacterScreenState createState() => SwitchCharacterScreenState();
}

class SwitchCharacterScreenState extends State<SwitchCharacterScreen> {
  bool _isEditMode = false;
  int? _activeCharacterId;

  @override
  void initState() {
    super.initState();
// Initialize the active character ID with the current character
    _activeCharacterId =
        Provider.of<CharacterManager>(context, listen: false).character.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Switch Character'), // Traduzido: '切换角色' para 'Switch Character'
        actions: [
          IconButton(
            icon: Icon(_isEditMode ? Icons.check : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditMode = !_isEditMode;
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Character>>(
        future: Provider.of<CharacterManager>(context, listen: false)
            .fetchAllCharacters(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading characters')); // Traduzido: '加载角色时出错' para 'Error loading characters'
          }
          final characters = snapshot.data!;
          return ListView.builder(
            itemCount: characters.length,
            itemBuilder: (context, index) {
              final character = characters[index];
              final isActive = character.id == _activeCharacterId;
              return Card(
                child: ListTile(
                  title: Text(character.name),
                  onTap: () {
                    setState(() {
                      _activeCharacterId = character.id;
                      Provider.of<CharacterManager>(context, listen: false)
                          .setCurrentCharacter(character);
                    });
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isActive) const Icon(Icons.check, color: Colors.green),
                      if (_isEditMode)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showEditCharacterDialog(context, character);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                await Provider.of<CharacterManager>(context,
                                    listen: false)
                                    .deleteCharacter(character.id);
                                setState(
                                        () {}); // Refresh the UI after deletion
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'addCharacter',
            onPressed: () {
              _showAddCharacterDialog(context);
            },
            tooltip: 'Add New Character',
            child: const Icon(Icons.add), // Traduzido: '新增角色' para 'Add New Character'
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'importCharacter',
            onPressed: () => _importCharacter(context),
            tooltip: 'Import Character',
            child: const Icon(Icons.file_upload), // Traduzido: '导入角色' para 'Import Character'
          ),
        ],
      ),
    );
  }

  Future<void> _importCharacter(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        String filePath = result.files.single.path!;
        String jsonString = await File(filePath).readAsString();
        Map<String, dynamic> characterData = jsonDecode(jsonString);

        await Provider.of<CharacterManager>(context, listen: false)
            .addCharacter(Character.fromJson(characterData));

        setState(() {}); // Refresh the UI after importing
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Character imported successfully')), // Traduzido: '角色导入成功' para 'Character imported successfully'
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to import character: $e')), // Traduzido: '导入角色失败: $e' para 'Failed to import character: $e'
      );
    }
  }

  void _showAddCharacterDialog(BuildContext context) {
    String characterName = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Character'), // Traduzido: '新增角色' para 'Add New Character'
          content: TextField(
            decoration: const InputDecoration(labelText: 'Character Name'), // Traduzido: '角色名' para 'Character Name'
            onChanged: (value) {
              characterName = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'), // Traduzido: '取消' para 'Cancel'
            ),
            ElevatedButton(
              onPressed: () async {
                if (characterName.isNotEmpty) {
                  final newCharacter = Character.empty();
                  newCharacter.name = characterName;
                  await Provider.of<CharacterManager>(context, listen: false)
                      .addCharacter(newCharacter);
                  setState(() {}); // Refresh the UI after adding
                }
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'), // Traduzido: '确认' para 'Confirm'
            ),
          ],
        );
      },
    );
  }

  void _showEditCharacterDialog(BuildContext context, Character character) {
    String characterName = character.name;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Character Name'), // Traduzido: '修改角色名' para 'Edit Character Name'
          content: TextField(
            decoration: const InputDecoration(labelText: 'Character Name'), // Traduzido: '角色名' para 'Character Name'
            controller: TextEditingController(text: characterName),
            onChanged: (value) {
              characterName = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'), // Traduzido: '取消' para 'Cancel'
            ),
            ElevatedButton(
              onPressed: () async {
                if (characterName.isNotEmpty) {
                  Provider.of<CharacterManager>(context, listen: false)
                      .updateCharacter({'name': characterName});
                  setState(() {}); // Refresh the UI after updating
                }
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'), // Traduzido: '确认' para 'Confirm'
            ),
          ],
        );
      },
    );
  }
}