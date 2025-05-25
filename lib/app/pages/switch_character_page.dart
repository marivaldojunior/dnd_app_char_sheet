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
    _activeCharacterId =
        Provider.of<CharacterManager>(context, listen: false).character.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Switch Character'),
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
        future: Provider.of<CharacterManager>(this.context, listen: false)
            .fetchAllCharacters(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading characters'));
          }
          final characters = snapshot.data!;
          return ListView.builder(
            itemCount: characters.length,
            itemBuilder: (listViewContext, index) {
              final character = characters[index];
              final isActive = character.id == _activeCharacterId;
              return Card(
                child: ListTile(
                  title: Text(character.name),
                  onTap: () {
                    setState(() {
                      _activeCharacterId = character.id;
                      Provider.of<CharacterManager>(this.context, listen: false)
                          .setCurrentCharacter(character);
                    });
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isActive)
                        const Icon(Icons.check, color: Colors.green),
                      if (_isEditMode)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showEditCharacterDialog(character);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final characterManager = Provider.of<CharacterManager>(this.context, listen: false);
                                await characterManager.deleteCharacter(character.id);
                                if (!mounted) return;
                                setState(() {});
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
              _showAddCharacterDialog();
            },
            tooltip: 'Add New Character',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'importCharacter',
            onPressed: _importCharacter,
            tooltip: 'Import Character',
            child: const Icon(Icons.file_upload),
          ),
        ],
      ),
    );
  }

  Future<void> _importCharacter() async {
    FilePickerResult? result;
    try {
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (!mounted) return;

      if (result != null) {
        String filePath = result.files.single.path!;
        String jsonString = await File(filePath).readAsString();

        if (!mounted) return;

        Map<String, dynamic> characterData = jsonDecode(jsonString);
        final characterManager = Provider.of<CharacterManager>(context, listen: false);
        await characterManager.addCharacter(Character.fromJson(characterData));

        if (!mounted) return;
        setState(() {});

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Character imported successfully')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to import character: $e')),
      );
    }
  }

  void _showAddCharacterDialog() {
    String characterName = '';

    final BuildContext stateClassContext = context;

    showDialog(
      context: stateClassContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Add New Character'),
          content: TextField(
            decoration: const InputDecoration(labelText: 'Character Name'),
            onChanged: (value) {
              characterName = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (characterName.isNotEmpty) {
                  final characterManager = Provider.of<CharacterManager>(stateClassContext, listen: false);
                  final newCharacter = Character.empty();
                  newCharacter.name = characterName;

                  await characterManager.addCharacter(newCharacter);
                  if (!context.mounted) return;
                  setState(() {});
                }
                if (Navigator.of(dialogContext).canPop()) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showEditCharacterDialog(Character character) {
    String characterName = character.name;
    final BuildContext stateClassContext = context;

    showDialog(
      context: stateClassContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Edit Character Name'),
          content: TextField(
            decoration: const InputDecoration(labelText: 'Character Name'),
            controller: TextEditingController(text: characterName),
            onChanged: (value) {
              characterName = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (characterName.isNotEmpty) {
                  final characterManager = Provider.of<CharacterManager>(stateClassContext, listen: false);
                  characterManager.updateCharacter({
                    'id': character.id,
                    'name': characterName
                  });

                  if (!mounted) return;
                  setState(() {});
                }
                if (Navigator.of(dialogContext).canPop()) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}